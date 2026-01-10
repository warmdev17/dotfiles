function wash --description 'Wash CLI (fish) — tạo group/subgroup/repo hàng loạt trên GitLab & init/push repo local'
    # ====== GLOBAL CONFIG PATH (helpers cần nhìn thấy) ======
    if not set -q WASH_CFG
        set -g WASH_CFG "$HOME/.config/wash/config.json"
    end

    # ====== CONFIG HELPERS ======
    function _wash_cfg_init
        if test -z "$WASH_CFG"
            echo "❌ Lỗi: biến WASH_CFG chưa được set"
            return 1
        end
        mkdir -p (dirname -- $WASH_CFG)
        if not test -f $WASH_CFG
            printf '{ "host":"", "branch":"main", "group_path":"" }\n' >$WASH_CFG
        end
    end

    function _wash_cfg_get
        # usage: _wash_cfg_get key
        set -l key $argv[1]
        _wash_cfg_init; or return 1
        jq -r --arg k "$key" '.[$k] // ""' $WASH_CFG
    end

    function _wash_cfg_set
        # usage: _wash_cfg_set key value
        set -l key $argv[1]
        set -l val $argv[2]
        _wash_cfg_init; or return 1
        set -l tmp (mktemp)
        jq --arg k "$key" --arg v "$val" '.[$k] = $v' $WASH_CFG >$tmp
        mv $tmp $WASH_CFG
    end

    # urlencode bằng jq (không cần python)
    function _wash_urlencode
        set -l s $argv[1]
        echo $s | jq -rn --arg v "$s" '$v|@uri'
    end

    if test (count $argv) -eq 0
        wash --help
        return 0
    end

    set -l cmd $argv[1]
    set -e argv[1] # shift

    switch $cmd
        # ====== HELP ======
        case -h --help help
            echo
            echo "Wash (fish) — lệnh:"
            echo "  wash config   [--host <HOST>] [--branch <BRANCH>] [--group-path <GROUP_PATH>] [--show]"
            echo "  wash group    --name <NAME> --path <PATH> [--visibility public|private|internal]"
            echo "  wash subgroup --parent-id <GROUP_ID> --name <NAME> --path <PATH> [--visibility public|private|internal]"
            echo "  wash repos    [--subgroup-id <NS_ID>] [--subgroup-path <LOCAL_OR_SUBPATH>] --count <N> [--prefix Baitap] [--host ...] [--branch-name ...] [--verbose]"
            echo "  wash submit --all   # Chạy BÊN TRONG 1 session (vd: session1)"
            echo
            echo "Ghi chú:"
            echo "  - Config: $WASH_CFG (lưu host, branch, group_path)."
            echo "  - Không có --subgroup-id: dùng group_path trong config + --subgroup-path để build full_path."
            echo "  - Có --subgroup-id: lấy full_path qua API (chính xác tuyệt đối)."
            echo
            return 0

            # ====== CONFIG ======
        case config
            set -l host ''
            set -l branch ''
            set -l group_path ''
            set -l show 0

            while test (count $argv) -gt 0
                switch $argv[1]
                    case --host
                        set host $argv[2]
                        set -e argv[1..2]
                    case --branch
                        set branch $argv[2]
                        set -e argv[1..2]
                    case --group-path
                        set group_path $argv[2]
                        set -e argv[1..2]
                    case --show
                        set show 1
                        set -e argv[1]
                    case '*'
                        echo "❌ Unknown flag: $argv[1]"
                        return 1
                end
            end

            if test $show -eq 1
                _wash_cfg_init; or return 1
                cat $WASH_CFG
                echo
                return 0
            end

            if test -n "$host"
                _wash_cfg_set host $host; or return 1
                echo "✅ set host = $host"
            end
            if test -n "$branch"
                _wash_cfg_set branch $branch; or return 1
                echo "✅ set branch = $branch"
            end
            if test -n "$group_path"
                _wash_cfg_set group_path $group_path; or return 1
                echo "✅ set group_path = $group_path"
            end
            if test -z "$host" -a -z "$branch" -a -z "$group_path"
                echo "ℹ️ Không có thay đổi. Dùng --show để xem config hiện tại."
            end
            return 0

            # ====== GROUP ======
        case group
            set -l name ''
            set -l path ''
            set -l visibility private

            while test (count $argv) -gt 0
                switch $argv[1]
                    case --name
                        set name $argv[2]
                        set -e argv[1..2]
                    case --path
                        set path $argv[2]
                        set -e argv[1..2]
                    case --visibility
                        set visibility $argv[2]
                        set -e argv[1..2]
                    case '*'
                        echo "❌ Unknown flag: $argv[1]"
                        return 1
                end
            end

            if test -z "$path"
                echo "❌ Thiếu --path"
                return 1
            end
            if test -z "$name"
                set name "$path" # mặc định name = path
            end

            echo "🚀 Tạo group: $name ($path) — visibility=$visibility"
            set -l res (glab api -X POST /groups -f name="$name" -f path="$path" -f visibility="$visibility" 2>/dev/null)
            if test $status -ne 0 -o -z "$res"
                echo "❌ glab api lỗi khi tạo group"
                return 1
            end
            set -l gid (echo $res | jq -r '.id')
            set -l url (echo $res | jq -r '.web_url')
            echo "✅ Group ID: $gid"
            echo "🔗 $url"

            _wash_cfg_set group_path $path; or return 1
            echo "📝 Saved config: group_path = $path"
            return 0

            # ====== SUBGROUP ======
        case subgroup
            set -l parent_id ''
            set -l name ''
            set -l path ''
            set -l visibility private

            while test (count $argv) -gt 0
                switch $argv[1]
                    case --parent-id
                        set parent_id $argv[2]
                        set -e argv[1..2]
                    case --name
                        set name $argv[2]
                        set -e argv[1..2]
                    case --path
                        set path $argv[2]
                        set -e argv[1..2]
                    case --visibility
                        set visibility $argv[2]
                        set -e argv[1..2]
                    case '*'
                        echo "❌ Unknown flag: $argv[1]"
                        return 1
                end
            end

            if test -z "$parent_id" -o -z "$name" -o -z "$path"
                echo "❌ Thiếu --parent-id hoặc --name hoặc --path"
                return 1
            end

            echo "🚀 Tạo subgroup: $name ($path) dưới parent_id=$parent_id — visibility=$visibility"
            set -l res (glab api -X POST /groups -f name="$name" -f path="$path" -f parent_id="$parent_id" -f visibility="$visibility" 2>/dev/null)
            if test $status -ne 0 -o -z "$res"
                echo "❌ glab api lỗi khi tạo subgroup"
                return 1
            end
            set -l sgid (echo $res | jq -r '.id')
            set -l url (echo $res | jq -r '.web_url')
            echo "✅ Subgroup ID: $sgid"
            echo "🔗 $url"
            return 0

            # ====== REPOS ======
        case repos
            set -l ns_id '' # subgroup namespace id (tuỳ chọn, ưu tiên nếu có)
            set -l ns_path '' # base path LOCAL hoặc subpath (vd: session1)
            set -l count ''
            set -l prefix Baitap
            set -l host (_wash_cfg_get host)
            set -l branch_name (_wash_cfg_get branch)
            set -l verbose 0 # <-- thêm flag --verbose để debug khi cần

            if test -z "$host"
                set host 'git.rikkei.edu.vn'
            end
            if test -z "$branch_name"
                set branch_name main
            end

            while test (count $argv) -gt 0
                switch $argv[1]
                    case --subgroup-id
                        set ns_id $argv[2]
                        set -e argv[1..2]
                    case --subgroup-path
                        set ns_path $argv[2]
                        set -e argv[1..2]
                    case --count
                        set count $argv[2]
                        set -e argv[1..2]
                    case --prefix
                        set prefix $argv[2]
                        set -e argv[1..2]
                    case --host
                        set host $argv[2]
                        set -e argv[1..2]
                    case --branch-name
                        set branch_name $argv[2]
                        set -e argv[1..2]
                    case --verbose
                        set verbose 1
                        set -e argv[1]
                    case '*'
                        echo "❌ Unknown flag: $argv[1]"
                        return 1
                end
            end

            if test -z "$count"
                echo "❌ Thiếu --count"
                return 1
            end

            set -l full_path '' # full path trên GitLab để build remote
            set -l local_base '' # thư mục local để tạo/clone repo

            if test -n "$ns_id"
                set -l sg_info (glab api "/groups/$ns_id" 2>/dev/null)
                if test $status -ne 0 -o -z "$sg_info"
                    echo "❌ Không lấy được thông tin subgroup id=$ns_id"
                    return 1
                end
                set full_path (echo $sg_info | jq -r '.full_path') # vd: nextjs_k25_letrunghieu/session1
                set local_base (test -n "$ns_path"; and echo "$ns_path"; or echo "$full_path")
            else
                set -l cfg_group_path (_wash_cfg_get group_path)
                if test -z "$cfg_group_path"
                    echo "❌ Thiếu --subgroup-id và chưa có group_path trong config."
                    echo "   Cách 1: wash config --group-path <group_path>"
                    echo "   Cách 2: cung cấp --subgroup-id để tool tự lấy full_path qua API."
                    return 1
                end
                if test -z "$ns_path"
                    echo "❌ Không có --subgroup-path. Khi không dùng --subgroup-id, cần chỉ rõ session/subpath (vd: --subgroup-path session1)."
                    return 1
                end

                if string match -q "$cfg_group_path/*" -- "$ns_path"
                    set full_path "$ns_path"
                else
                    set full_path "$cfg_group_path/$ns_path"
                end

                set -l found (glab api "/groups?search=$full_path" | jq -r 'map(select(.full_path == "'$full_path'"))[0].id')
                if test -n "$found" -a "$found" != null
                    set ns_id $found
                else
                    echo "⚠️  Không tìm ra subgroup id từ full_path: $full_path — vẫn tiếp tục nhưng có thể lỗi tạo project."
                end
                set local_base "$full_path"
            end

            echo "🚀 Tạo $count repo"
            echo "   🌐 full_path (remote): $full_path"
            echo "   🗂️  local base dir   : $local_base"
            echo "   🧪 default branch    : $branch_name"
            echo "   🏷️  prefix            : $prefix"
            echo "   🖥️  host              : $host"

            mkdir -p "$local_base"

            for i in (seq 1 $count)
                set -l name "$prefix$i"
                set -l path (string lower -- (string replace -ra '[^A-Za-z0-9._-]' '' "$name"))
                echo "→ Tạo/đồng bộ project: $name ($path)"

                # ==== TẠO PROJECT + GHI LOG QUIET ====
                set -l log "/tmp/wash_create_project_$name.log"
                glab api -i -X POST /projects \
                    -F "name=$name" \
                    -F "path=$path" \
                    -F "namespace_id=$ns_id" \
                    -F "visibility=public" >$log 2>&1

                # Bắt HTTP code từ header trong file log
                set -l http_code (string match -r '^HTTP/.* ([0-9]{3})' < $log | awk '{print $2}')
                # Body JSON (thường dòng cuối)
                set -l json (tail -n 1 $log)

                set -l ssh_url ''
                set -l web ''
                set -l pid ''

                if test "$http_code" = 201
                    set pid (echo $json | jq -r '.id')
                    set web (echo $json | jq -r '.web_url')
                    set ssh_url (echo $json | jq -r '.ssh_url_to_repo')
                    echo "   ✅ Created: $web"
                else
                    # Không 201 → thử lookup project hiện có theo full_path/path
                    set -l encoded (_wash_urlencode "$full_path/$path")
                    set -l existing (glab api "/projects/$encoded" 2>/dev/null)

                    if test -n "$existing"
                        set pid (echo $existing | jq -r '.id')
                        set web (echo $existing | jq -r '.web_url')
                        set ssh_url (echo $existing | jq -r '.ssh_url_to_repo')
                        echo "   ℹ️ Tồn tại : $web"
                    else
                        echo "   ❌ Lỗi tạo: $name (HTTP $http_code)"
                        if test $verbose -eq 1
                            echo "      ↳ Log: $log"
                            if command -v bat >/dev/null
                                bat -pp $log | tail -n 40
                            else
                                tail -n 40 $log
                            end
                        else
                            echo "      ↳ Dùng --verbose để xem chi tiết (log: $log)"
                        end
                        continue
                    end
                end

                # ==== ĐỒNG BỘ LOCAL: clone nếu chưa có ====
                set -l local_dir "$local_base/$name"
                if not test -d "$local_dir/.git"
                    echo "   ⬇️  clone về: $local_dir"
                    if test -n "$ssh_url" -a "$ssh_url" != null
                        git clone "$ssh_url" "$local_dir" >/dev/null
                        if test $status -ne 0
                            echo "   ⚠️  clone lỗi → fallback init + add remote"
                            mkdir -p "$local_dir"
                            pushd "$local_dir" >/dev/null
                            if not test -d ".git"
                                git init --initial-branch=$branch_name >/dev/null
                            end
                            set -l remote_url "git@$host:$full_path/$path.git"
                            git remote add origin "$remote_url" 2>/dev/null; or git remote set-url origin "$remote_url"
                            popd >/dev/null
                        end
                    else
                        echo "   ⚠️  không có ssh_url_to_repo → init + add remote"
                        mkdir -p "$local_dir"
                        pushd "$local_dir" >/dev/null
                        if not test -d ".git"
                            git init --initial-branch=$branch_name >/dev/null
                        end
                        set -l remote_url "git@$host:$full_path/$path.git"
                        git remote add origin "$remote_url" 2>/dev/null; or git remote set-url origin "$remote_url"
                        popd >/dev/null
                    end
                else
                    echo "   ✓ Local đã có: $local_dir"
                    # đảm bảo remote đúng
                    set -l remote_url "git@$host:$full_path/$path.git"
                    git -C "$local_dir" remote set-url origin "$remote_url"
                end
            end
            echo "🏁 Hoàn tất tạo/đồng bộ local tất cả repo."
            return 0

            # ====== SUBMIT ======
        case submit
            # chỉ chấp nhận cú pháp: wash submit --all (chạy BÊN TRONG thư mục session)
            set -l mode ""
            if test (count $argv) -gt 0
                set mode (string lower -- (string trim -- "$argv[1]"))
            end
            if test "$mode" != --all
                echo "❌ Dùng: wash submit --all (đứng bên trong thư mục session, ví dụ: session1)"
                return 1
            end

            set -l session (basename (pwd))
            echo "🚀 Submit toàn bộ bài trong session: $session"

            # Chỉ tìm repo .git 1 cấp con: ./BaitapX/.git
            set -l repos (find . -mindepth 2 -maxdepth 2 -type d -name ".git" -prune | sed 's|/\.git||')

            if test (count $repos) -eq 0
                echo "ℹ️  Không tìm thấy repo nào dạng ./BaitapX/.git trong $session"
                return 0
            end

            for repo in $repos
                pushd "$repo" >/dev/null
                set -l baitap (basename (pwd))

                set -l status_porcelain (git status --porcelain)
                if test -z "$status_porcelain"
                    echo "📂 $session/$baitap: ❌ Không có thay đổi, bỏ qua."
                else
                    # nhánh hiện tại (fallback từ config → main)
                    set -l current_branch (git rev-parse --abbrev-ref HEAD ^/dev/null)
                    if test -z "$current_branch" -o "$current_branch" = HEAD
                        set current_branch (_wash_cfg_get branch)
                        if test -z "$current_branch"
                            set current_branch main
                        end
                    end

                    echo "📂 $session/$baitap: ✅ Có thay đổi → commit & push..."
                    git add .
                    git commit -m "submit $session $baitap" >/dev/null
                    git push -u origin $current_branch >/dev/null
                    if test $status -eq 0
                        echo "   ⬆️  pushed to origin/$current_branch"
                    else
                        echo "   ⚠️  push lỗi (kiểm tra remote/permission)"
                    end
                end
                popd >/dev/null
            end

            echo "🏁 Hoàn tất submit tất cả bài trong $session!"
            return 0

            # ====== UNKNOWN ======
        case '*'
            echo "❌ Unknown command: $cmd"
            echo "Dùng: wash --help"
            return 1
    end
end
