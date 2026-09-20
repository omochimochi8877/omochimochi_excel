#!/usr/bin/env bash
set -euo pipefail
OUT_DIR="video-automation/output"
mkdir -p "$OUT_DIR"
FONT="/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"

make_scene() {
  local name="$1"; local duration="$2"; local bg="$3"; local title="$4"; local filter="$5"
  ffmpeg -y -f lavfi -i "color=c=${bg}:s=1280x720:r=30:d=${duration}" \
    -vf "drawtext=fontfile=${FONT}:text='${title}':fontcolor=white:fontsize=38:x=(w-text_w)/2:y=45:alpha=0.92,${filter}" \
    -c:v libx264 -preset veryfast -crf 23 -pix_fmt yuv420p "$OUT_DIR/${name}.mp4"
}

make_scene "01_wake" 60 "0x9edcf5" "The Little Star" "drawbox=x='640+170*sin(2*PI*t/4)':y='380+55*cos(2*PI*t/4)':w=130:h=130:color=white@0.92:t=fill,drawbox=x='500+110*sin(2*PI*t/5)':y='470':w=55:h=55:color=0x6f8cff@0.9:t=fill"
make_scene "02_discovery" 60 "0xa8e6a3" "A little light..." "drawbox=x='650+240*sin(2*PI*t/6)':y='330+90*cos(2*PI*t/5)':w=80:h=80:color=0xffe66d@1:t=fill,drawbox=x='520+160*sin(2*PI*t/4)':y='470':w=120:h=120:color=white@0.88:t=fill"
make_scene "03_friends" 60 "0x83cfa0" "Friends appear" "drawbox=x='500+70*sin(2*PI*t/4)':y='410':w=110:h=110:color=white@0.9:t=fill,drawbox=x='690+70*sin(2*PI*t/4+PI)':y='410':w=110:h=110:color=0xffe68a@0.9:t=fill,drawbox=x='880+70*sin(2*PI*t/4)':y='410':w=110:h=110:color=0xa7f0dc@0.9:t=fill"
make_scene "04_journey" 60 "0x77b9d9" "Follow the light" "drawbox=x='580+300*sin(2*PI*t/8)':y='250+120*cos(2*PI*t/7)':w=70:h=70:color=0xfff4a7@1:t=fill,drawbox=x='640+260*sin(2*PI*t/8+PI)':y='420+80*cos(2*PI*t/6)':w=100:h=100:color=white@0.9:t=fill"
make_scene "05_home" 60 "0x26385e" "Together" "drawbox=x='450+20*sin(2*PI*t/3)':y='430':w=110:h=110:color=white@0.95:t=fill,drawbox=x='585+20*sin(2*PI*t/3+1)':y='430':w=110:h=110:color=0xffe68a@0.95:t=fill,drawbox=x='720+20*sin(2*PI*t/3+2)':y='430':w=110:h=110:color=0xa7f0dc@0.95:t=fill,drawbox=x='930':y='150':w=80:h=80:color=0xfff4c95d@1:t=fill"

printf "file '%s/01_wake.mp4'\nfile '%s/02_discovery.mp4'\nfile '%s/03_friends.mp4'\nfile '%s/04_journey.mp4'\nfile '%s/05_home.mp4'\n" "$OUT_DIR" "$OUT_DIR" "$OUT_DIR" "$OUT_DIR" "$OUT_DIR" > "$OUT_DIR/concat.txt"
ffmpeg -y -f concat -safe 0 -i "$OUT_DIR/concat.txt" -c copy -movflags +faststart "$OUT_DIR/little-star-5min.mp4"
rm -f "$OUT_DIR"/01_wake.mp4 "$OUT_DIR"/02_discovery.mp4 "$OUT_DIR"/03_friends.mp4 "$OUT_DIR"/04_journey.mp4 "$OUT_DIR"/05_home.mp4 "$OUT_DIR"/concat.txt
echo "Created $OUT_DIR/little-star-5min.mp4"
ls -lh "$OUT_DIR/little-star-5min.mp4"
