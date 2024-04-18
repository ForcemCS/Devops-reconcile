FROM ubuntu:22.04 as builder

#RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
#    && apt update \
#    && apt install -y git

WORKDIR /app
COPY . .

WORKDIR /app/config
RUN rm -rf lua \
    && chmod +x ./xlsx_trans.linux \
    && mkdir lua \
    && mkdir lua/scene_data \
    && mkdir lua/maze_map \
    && mkdir lua/scripts \
    && ./xlsx_trans.linux ./ ./lua/ \
    && cp -r scene_data/* lua/scene_data/ \
    && cp -r maze_map_lua/* lua/maze_map/ \
    && cp -r scripts/* lua/scripts/

WORKDIR /app/protobuf
RUN rm -rf .cache \
    && ./protobufmake.linux  

FROM ubuntu:22.04

#RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
#    && apt update \
#    && apt install -y git

RUN   ln -sv /usr/share/zoneinfo/Asia/Shanghai /etc/localtime 

COPY --from=builder /app/server /usr/data/bin
COPY --from=builder /app/protobuf/.cache /usr/data/protobuf
COPY --from=builder /app/config/lua /usr/data/config
COPY --from=builder /app/env /usr/data/svr/

WORKDIR /usr/data/svr

EXPOSE  10002
EXPOSE  10003
ENTRYPOINT [ "../bin/skynet/skynet", "main_logic_real" ]
