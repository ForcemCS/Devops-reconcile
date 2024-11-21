awk -F'/' '{
  if ($2 != "") {
    key = $2;
    for (i = 3; i <= NF-1; i++) { # 构建 key，包含中间的目录
      key = key "/" $i;
    }
    if (current != key) {
      if (current != "") print "";
      current = key;
      print current;
    }
    print $NF;
  }
}' 1.txt
