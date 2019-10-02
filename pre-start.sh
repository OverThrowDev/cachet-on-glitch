if [ -f "/app/postinstall" ]; then
rm postinstall
sleep 5
# Refresh the app so everything updates
curl -s -X POST http://localhost:1083/refresh
fi
echo Starting up...
