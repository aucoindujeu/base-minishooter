play:
	love ./src/

love:
	mkdir -p dist
	cd src && zip -r ../dist/MiniShooter.love .

js: love
	love.js -c --title="Mini Shooter" ./dist/MiniShooter.love ./dist/js
