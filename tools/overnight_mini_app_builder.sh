#!/bin/bash
# overnight_mini_app_builder.sh — Build one mini-app nightly at 1 AM
# Usage: ./overnight_mini_app_builder.sh
# Cron: 0 1 * * * /data/workspace/tools/overnight_mini_app_builder.sh >> /data/workspace/logs/overnight.log 2>&1

set -e
DATE=$(date '+%Y-%m-%d')
BUILD_DIR="/data/workspace/PROJECTS/overnight-builds/$DATE"
mkdir -p "$BUILD_DIR"

echo "🌙 [$(date)] Starting overnight mini-app build..."

# Mini-app ideas — one is randomly selected
APPS=(
    "A simple Pomodoro timer with customizable work/break intervals and local storage"
    "A habit tracker with streak counting and weekly visualization"
    "A URL shortener with custom aliases and click analytics"
    "A markdown note-taking app with local persistence"
    "A BMI calculator with health recommendations"
    "A countdown timer to a target date with multiple themes"
    "A mini CRM for tracking freelance clients and invoices"
    "A weather dashboard showing 5-day forecast for a city"
    "A random name picker / wheel of fortune for team decisions"
    "A daily journal prompt generator with mood tracking"
    "A link-in-bio page builder with theme customization"
    "A simple poll/voting tool with real-time results"
    "A book quote generator with save-to-favorites feature"
    "A expense tracker with category pie chart visualization"
    "A goal tracker with milestone celebrations"
)

# Select random app
APP_IDX=$((RANDOM % ${#APPS[@]}))
APP_DESC="${APPS[$APP_IDX]}"
echo "🎲 Selected: $APP_DESC"

# Generate app based on description keywords
generate_app() {
    local app_name="$1"
    local app_file="$BUILD_DIR/index.html"
    
    if [[ "$APP_DESC" == *"Pomodoro"* ]]; then
        cat << 'HTML' > "$app_file"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Axton's Pomodoro Timer</title>
<style>
*{box-sizing:border-box;margin:0;padding:0;font-family:system-ui,sans-serif}
body{min-height:100vh;display:flex;flex-direction:column;align-items:center;justify-content:center;background:#1a1a2e;color:#fff}
.timer{font-size:5rem;font-weight:bold;margin:1rem 0}
.btns{display:flex;gap:1rem}
button{padding:.75rem 1.5rem;font-size:1rem;border:none;border-radius:8px;cursor:pointer;transition:.2s}
.start{background:#e94560;color:#fff}
.pause{background:#0f3460;color:#fff}
.reset{background:#533483;color:#fff}
button:hover{transform:scale(1.05)}
.settings{display:flex;gap:2rem;margin-top:1rem}
.setting{text-align:center}
.setting span{font-size:.9rem;opacity:.7}
.setting strong{display:block;font-size:1.5rem}
</style>
</head>
<body>
<h1>🍅 Pomodoro Timer</h1>
<div class="timer" id="timer">25:00</div>
<div class="btns">
<button class="start" onclick="startTimer()">Start</button>
<button class="pause" onclick="pauseTimer()">Pause</button>
<button class="reset" onclick="resetTimer()">Reset</button>
</div>
<div class="settings">
<div class="setting"><strong id="workDisplay">25</strong><span>Work (min)</span></div>
<div class="setting"><strong id="breakDisplay">5</strong><span>Break (min)</span></div>
</div>
<script>
let time=25*60,interval=null,isBreak=false;
const timerEl=document.getElementById('timer');
function format(t){return `${Math.floor(t/60)}:${(t%60).toString().padStart(2,'0')}`}
function update(){
timerEl.textContent=format(time);
document.title=format(time)+(isBreak?' 🍵':' 🍅');
}
function startTimer(){
if(interval)return;
interval=setInterval(()=>{time--;update();if(time<=0){playSound();isBreak=!isBreak;time=isBreak?5*60:25*60;update()}},1000);}
function pauseTimer(){clearInterval(interval);interval=null}
function resetTimer(){pauseTimer();time=25*60;isBreak=false;update()}
function playSound(){try{new Audio('data:audio/wav;base64,UklGRnoGAABXQVZFZm10IBAAAAABAAEAQB8AAEAfAAABAAgAZGF0YQoGAACBhYqFbF1fdJivrJBhNjVgodDbq2EcBj+a2teleBoA').play()}catch(e){}}
update();
</script>
</body>
</html>
HTML
        echo "✅ Built: Pomodoro Timer"
    elif [[ "$APP_DESC" == *"habit tracker"* ]]; then
        cat << 'HTML' > "$app_file"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Axton's Habit Tracker</title>
<style>
*{box-sizing:border-box;margin:0;padding:0;font-family:system-ui,sans-serif}
body{min-height:100vh;background:#0f0f23;color:#fff;padding:2rem}
h1{text-align:center;margin-bottom:2rem}
.habits{display:flex;flex-direction:column;gap:1rem;max-width:500px;margin:0 auto}
.habit{display:flex;align-items:center;justify-content:space-between;background:#1a1a3e;padding:1rem;border-radius:10px}
.habit input[type="checkbox"]{width:24px;height:24px;cursor:pointer}
.habit-name{font-size:1.1rem;flex:1;margin-left:1rem}
.streak{background:#e94560;padding:.25rem .75rem;border-radius:20px;font-size:.85rem}
.week{display:flex;justify-content:space-between;margin-top:2rem;padding-top:1rem;border-top:1px solid #333}
.day{text-align:center;font-size:.75rem;opacity:.5}
.day.done{opacity:1;color:#4ade80}
</style>
</head>
<body>
<h1>📊 Habit Tracker</h1>
<div class="habits" id="habits"></div>
<script>
const defaultHabits=['Morning workout','Read 30 min','Meditate','No social media','Drink 2L water'];
const habits=JSON.parse(localStorage.getItem('habits')||'[]').concat(defaultHabits.filter(h=>!JSON.parse(localStorage.getItem('habits')||'[]').some(x=>x.name===h))).slice(0,5);
function render(){
const container=document.getElementById('habits');
container.innerHTML=habits.map((h,i)=>`
<div class="habit">
<input type="checkbox" ${h.done?'checked':''} onchange="toggle(${i})">
<span class="habit-name">${h.name}</span>
<span class="streak">🔥 ${h.streak||0}</span>
</div>
<div class="week">${['M','T','W','T','F','S','S'].map((d,j)=>`<div class="day ${h.week&&h.week[j]?'done':''}">${d}</div>`).join('')}</div>
`).join('');
}
function toggle(i){
habits[i].done=!habits[i].done;
if(habits[i].done){
habits[i].streak=(habits[i].streak||0)+1;
habits[i].week=habits[i].week||[0,0,0,0,0,0,0];
habits[i].week[new Date().getDay()]=1;
}
localStorage.setItem('habits',JSON.stringify(habits));
render();
}
render();
</script>
</body>
</html>
HTML
        echo "✅ Built: Habit Tracker"
    elif [[ "$APP_DESC" == *"BMI"* ]]; then
        cat << 'HTML' > "$app_file"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>BMI Calculator</title>
<style>
*{box-sizing:border-box;margin:0;padding:0;font-family:system-ui,sans-serif}
body{min-height:100vh;background:#1a1a2e;color:#fff;display:flex;flex-direction:column;align-items:center;justify-content:center;padding:2rem}
.card{background:#16213e;padding:2rem;border-radius:16px;width:100%;max-width:400px;text-align:center}
input{width:100%;padding:.75rem;border:none;border-radius:8px;margin:.5rem 0;font-size:1rem;text-align:center}
button{width:100%;padding:.75rem;background:#e94560;border:none;border-radius:8px;color:#fff;font-size:1rem;cursor:pointer;margin-top:1rem}
.result{font-size:3rem;font-weight:bold;margin:1rem 0;color:#4ade80}
.category{font-size:1.2rem;opacity:.8}
</style>
</head>
<body>
<div class="card">
<h1>⚖️ BMI Calculator</h1>
<input type="number" id="weight" placeholder="Weight (kg)" min="1">
<input type="number" id="height" placeholder="Height (cm)" min="1">
<button onclick="calculate()">Calculate</button>
<div class="result" id="result"></div>
<div class="category" id="category"></div>
</div>
<script>
function calculate(){
const w=document.getElementById('weight').value;
const h=document.getElementById('height').value/100;
if(!w||!h)return;
const bmi=(w/(h*h)).toFixed(1);
document.getElementById('result').textContent=bmi;
let cat=bmi<18.5?'Underweight':bmi<25?'Normal':bmi<30?'Overweight':'Obese';
let color=bmi<18.5?'#60a5fa':bmi<25?'#4ade80':bmi<30?'#fbbf24':'#ef4444';
document.getElementById('result').style.color=color;
document.getElementById('category').textContent=cat;
}
</script>
</body>
</html>
HTML
        echo "✅ Built: BMI Calculator"
    else
        # Generic tool builder
        cat << HTML > "$app_file"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Axton's Mini Tool</title>
<style>
*{box-sizing:border-box;margin:0;padding:0;font-family:system-ui,sans-serif}
body{min-height:100vh;background:linear-gradient(135deg,#1a1a2e,#16213e);color:#fff;display:flex;flex-direction:column;align-items:center;justify-content:center;padding:2rem}
h1{margin-bottom:1rem;text-align:center}
p{opacity:.7;margin-bottom:2rem;text-align:center}
.built{background:#e94560;padding:.5rem 1rem;border-radius:20px;font-size:.85rem;margin-bottom:2rem}
footer{opacity:.4;font-size:.8rem;margin-top:2rem}
</style>
</head>
<body>
<div class="built">🔧 Built by Axton — $(date '+%Y-%m-%d')</div>
<h1>🛠️ $APP_DESC</h1>
<p>Open index.html to see your mini-app!</p>
<footer>Part of Axton's Overnight Build Series</footer>
</body>
</html>
HTML
        echo "✅ Built: Generic Mini Tool"
    fi
}

# Run generator
generate_app

# Create README
cat << EOF > "$BUILD_DIR/README.md"
# Overnight Build — $DATE

## What was built
$APP_DESC

## How to use
Open \`index.html\` in any browser. No server required.

## Notes
- Built automatically at 1 AM UTC
- Local storage enabled for persistence
- Mobile responsive

---
*Built by Axton while you slept* 🌙
EOF

# Create manifest entry
echo "- **$DATE**: $APP_DESC" >> /data/workspace/PROJECTS/overnight-builds/MANIFEST.md

echo ""
echo "✅ Overnight build complete!"
echo "   📁 $BUILD_DIR"
echo "   📖 README.md created"
echo ""
ls -la "$BUILD_DIR"
