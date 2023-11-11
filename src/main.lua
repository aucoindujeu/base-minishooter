-- **********************************
-- Variables utilisées dans le jeu
-- *********************************

-- Constantes
LARGEUR_ECRAN = 800
HAUTEUR_ECRAN = 600

local etatJeu = 'menu'
local chrono = 0
local chronoDepart = 5
-- Sprite Joueur
local joueureuse = {}
joueureuse.img = love.graphics.newImage('images/joueureuse.png')
joueureuse.imgExplosion = love.graphics.newImage('images/explosion_joueureuse.png')
joueureuse.l = joueureuse.img:getWidth()
joueureuse.h = joueureuse.img:getHeight()
joueureuse.x = 0 
joueureuse.y = 0 
joueureuse.vx = 0
joueureuse.vy = 0
joueureuse.acceleration = 500
joueureuse.vitessemax = 500
joueureuse.touche = false
joueureuse.delai = 1 

-- Sprites Ennemis

local lstEnnemis = {}

-- Tirs

local lstTirs = {}

-- *****************
-- Fonctions
-- *****************

-- Créations ennemis

function creerEnnemi()

  local ennemi = {}
  ennemi.img = love.graphics.newImage('images/ennemi.png')
  ennemi.imgExplosion = love.graphics.newImage('images/explosion_ennemi.png')
  ennemi.h = ennemi.img:getHeight()
  ennemi.l = ennemi.img:getWidth()
  ennemi.x = math.random(LARGEUR_ECRAN)
  ennemi.y = 0
  if ennemi.x > LARGEUR_ECRAN/2 then
    ennemi.vx = - 50 - math.random(20)
  else
    ennemi.vx = 50 + math.random(20)
  end
  ennemi.vy = -100 - math.random(100)
  ennemi.touche = false
  ennemi.delai = 1

  table.insert(lstEnnemis, ennemi)

end


-- test collision méthode bounding boxes
function testeCollision(pX1, pY1, pL1, pH1, pX2, pY2, pL2, pH2)

  return pX1 < pX2 + pL2 and pX2 < pX1 + pL1 and pY1 < pY2 + pH2 and pY2 < pY1 + pH1

end

-- ****************************
-- INITIALISATION DE LA PARTIE
-- ****************************

function initJeu()

  chrono = chronoDepart
 
  -- Initialisation joueureuse
  joueureuse.x = (LARGEUR_ECRAN - joueureuse.l)/2
  joueureuse.y = HAUTEUR_ECRAN - joueureuse.h * 2
  joueureuse.touche = false

  -- Initialisation ennemis
  lstEnnemis = {}

  -- Initialisation tirs
  lstTirs = {}

end


function love.load()

  love.window.setMode(LARGEUR_ECRAN, HAUTEUR_ECRAN)
  love.window.setTitle('Mini shooter - Code Club CimeLab - Au Coin du jeu')
  
  police = love.graphics.newFont('fontes/police.ttf', 20)
  love.graphics.setFont(police)

  initJeu()

end


-- ******************
-- MISE À JOUR JEU (update)
-- ******************

-- MAJ MENU
function majMenu()

end

-- MAJ JOUEUREUSE
function majJoueureuse(dt)

  if joueureuse.touche == false then

    if love.keyboard.isDown('up') then
      joueureuse.vy = joueureuse.vy - joueureuse.acceleration * dt
      if joueureuse.vy < - joueureuse.vitessemax then
        joueureuse.vy = - joueureuse.vitessemax
      end
    end

    if love.keyboard.isDown('down') then
      joueureuse.vy = joueureuse.vy + joueureuse.acceleration * dt
      if joueureuse.vy > joueureuse.vitessemax then
        joueureuse.vy = joueureuse.vitessemax
      end
    end

    if love.keyboard.isDown('right') then
      joueureuse.vx = joueureuse.vx + joueureuse.acceleration * dt
      if joueureuse.vx > joueureuse.vitessemax then
        joueureuse.vx = joueureuse.vitessemax
      end
    end

    if love.keyboard.isDown('left') then
      joueureuse.vx = joueureuse.vx - joueureuse.acceleration * dt
      if joueureuse.vx < -joueureuse.vitessemax then
        joueureuse.vx = -joueureuse.vitessemax
      end
    end

    joueureuse.x = joueureuse.x + joueureuse.vx * dt
    joueureuse.y = joueureuse.y + joueureuse.vy * dt

    if joueureuse.x < 0 then
      joueureuse.x = 0
    elseif joueureuse.x > LARGEUR_ECRAN - joueureuse.l then
      joueureuse.x = LARGEUR_ECRAN - joueureuse.l
    end

    if joueureuse.y < 0 then
      joueureuse.y = 0
    elseif joueureuse.y > HAUTEUR_ECRAN - joueureuse.h then
      joueureuse.y = HAUTEUR_ECRAN - joueureuse.h
    end

  elseif joueureuse.touche == true then

    if joueureuse.delai > 0 then
      joueureuse.delai = joueureuse.delai - dt
    else
      joueureuse.touche = false
    end

  end
end

-- MAJ ENNEMIS
function majEnnemis(dt)

  chrono = chrono - dt

  if chrono < 0 then
    creerEnnemi(lstEnnemis)
    chrono = chronoDepart - math.random(300) * dt 
  end

  for n = #lstEnnemis, 1, -1 do
    local ennemi = lstEnnemis[n]
    ennemi.x = ennemi.x + ennemi.vx * dt
    ennemi.y = ennemi.y - ennemi.vy * dt
    
    if testeCollision(ennemi.x, 
                      ennemi.y, 
                      ennemi.l, 
                      ennemi.h, 
                      joueureuse.x, 
                      joueureuse.y, 
                      joueureuse.l, 
                      joueureuse.h) then
      ennemi.touche = true
      joueureuse.touche = true
    end

    if ennemi.touche == true then
      if ennemi.delai > 0 then
        ennemi.delai = ennemi.delai - dt
      else
        table.remove(lstEnnemis, n)
      end
    end
  end

end

-- MAJ TIRS
function majTirs(dt)
end

-- UPDATE
function love.update(dt)
  
  if etatJeu == 'menu' then

    majMenu()

  elseif etatJeu == 'en jeu' then

    majJoueureuse(dt) 

    majEnnemis(dt)
  
    majTirs(dt)

  end

end

-- ***************
-- AFFICHAGE
-- ***************

-- AFFICHAGE MENU
function afficheMenu()

  love.graphics.printf('appuyer sur `espace` pour lancer le jeu',
                        0,
                        HAUTEUR_ECRAN/2,
                        LARGEUR_ECRAN,
                        'center')

end

-- AFFICHAGE JOUEUREUSE
function afficheJoueureuse()

  if joueureuse.touche == false then
    love.graphics.draw(joueureuse.img, joueureuse.x, joueureuse.y)
  else
    love.graphics.draw(joueureuse.imgExplosion, joueureuse.x, joueureuse.y)
  end

end

-- AFFICHAGE ENNEMIS
function afficheEnnemis()

  for k, ennemi in ipairs(lstEnnemis) do
    if ennemi.touche == false then
      love.graphics.draw(ennemi.img, ennemi.x, ennemi.y)
    else
      love.graphics.draw(ennemi.imgExplosion, ennemi.x, ennemi.y)
    end
  end


end

-- AFFICHAGE TIRS
function afficheTirs()
end

-- AFFICHAGE GAME OVER
function afficheGameOver()

end

-- DRAW
function love.draw()

  if etatJeu == 'menu' then
    
    afficheMenu()

  elseif etatJeu == 'en jeu' then

    afficheJoueureuse()
    afficheEnnemis()
    afficheTirs()

    love.graphics.print('j.x = '..tostring(joueureuse.x), 10, 10)
    love.graphics.print('j.y = '..tostring(joueureuse.y), 10, 40)
    love.graphics.print('j.vx = '..tostring(joueureuse.vx), 10, 70)
    love.graphics.print('j.vy = '..tostring(joueureuse.vy), 10, 100)
    love.graphics.print('chrono = '..tostring(chrono), 10, 130)

  elseif etatJeu == 'game over' then

    afficheGameOver()

  end

end

-- ******************
-- TOUCHES HORS-JEU
-- ******************

function love.keypressed(key)

  if key == 'escape' then
    love.event.quit()
  end

  if key== 'space' and etatJeu == 'menu' then
    etatJeu = 'en jeu'
  end

  if key == 'return' and etatJeu == 'game over' then
    etatJeu = 'menu'
  end

end
