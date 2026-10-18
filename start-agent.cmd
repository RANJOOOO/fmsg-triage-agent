@echo off
cd /d C:\Users\ADMIN\Desktop\fmsg-agent
REM Test mode: messages from your main address are triaged too. Delete the next line for real use.
set TEST_OWNER_AS_EXTERNAL=1
echo Starting fmsg triage agent as @alisabir_claudecode@fmsg.ai ... (close this window to stop)
node agent.js
pause
