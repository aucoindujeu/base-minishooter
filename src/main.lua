-- Les manettes de jeu ne son pas reconnues sur la version
-- en ligne générée par Love.js, on désactive donc ces manettes
-- si on détecte que l’environnement d’exécution est en ligne

-- Are we in love.js? Joysticks are not supported there.
-- https://github.com/Davidobot/love.js/issues/74
if love.system.getOS() == "web" then
  -- Joysticks don't work in love.js
  -- https://github.com/Davidobot/love.js/issues/41
  t.modules.joystick = false
end
--
-- **********************************
-- Variables utilisées dans le jeu
-- *********************************

-- Constantes
LARGEUR_ECRAN = 800
HAUTEUR_ECRAN = 600
DUREE_IMMOBILISATION = 1

local etatJeu = 'menu'
local chronoEnnemis = 0
local iniChronoEnnemis = 5
local cmptEnnemis = 0
local cmptAbattus = 0
local cmptAbordages = 0

-- fond / scrolling infini
local scrolling = {}
scrolling.camera = 0
scrolling.fond = love.graphics.newImage('images/fond.png')
scrolling.img = love.graphics.newImage('images/fond2.png')
scrolling.h = scrolling.img:getHeight()

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
joueureuse.acceleration = 800
joueureuse.vitessemax = 500
joueureuse.resistance = 300
joueureuse.touche = false
joueureuse.delai = 0 
joueureuse.chronoTir = 0

-- Sprites Ennemis

local lstEnnemis = {}

-- Tirs

local lstTirs = {}

local sonExplosion = love.audio.newSource('sons/explosion.wav', 'static')

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
  ennemi.delai = DUREE_IMMOBILISATION

  table.insert(lstEnnemis, ennemi)

end

function creerTir()

  local tir = {}
  tir.img = love.graphics.newImage('images/tir.png')
  tir.h = tir.img:getHeight()
  tir.l = tir.img:getWidth()
  tir.x = joueureuse.x + (joueureuse.l - tir.l)/2
  tir.y = joueureuse.y
  tir.vy = -500

  table.insert(lstTirs, tir)

end


-- test collision méthode bounding boxes
function testeCollision(pX1, pY1, pL1, pH1, pX2, pY2, pL2, pH2)

  return pX1 < pX2 + pL2 and pX2 < pX1 + pL1 and pY1 < pY2 + pH2 and pY2 < pY1 + pH1

end

-- ****************************
-- INITIALISATION DE LA PARTIE
-- ****************************

function initJeu()

  chronoEnnemis = iniChronoEnnemis 
  cmptEnnemis = 0
  cmptAbattus = 0
  cmptAbordages = 0
 
  -- Initialisation joueureuse
  joueureuse.x = (LARGEUR_ECRAN - joueureuse.l)/2
  joueureuse.y = HAUTEUR_ECRAN - joueureuse.h * 2
  joueureuse.touche = false
  joueureuse.delai = DUREE_IMMOBILISATION
  joueureuse.chronoTir = 0
  
  -- Initialisation ennemis
  lstEnnemis = {}

  -- Initialisation tirs
  lstTirs = {}

end


function love.load()

  love.window.setMode(LARGEUR_ECRAN, HAUTEUR_ECRAN)
  love.window.setTitle('Mini shooter - Code Club CimeLab - Au Coin du jeu')
  
  police = love.graphics.newFont('fontes/police.ttf', 15)
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

    -- DÉPLACEMENTS
    -- test flèches clavier    
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

    if love.keyboard.isDown() == false then
      if joueureuse.vx > 0 then
        joueureuse.vx = joueureuse.vx - joueureuse.resistance * dt
      else
        joueureuse.vx = joueureuse.vx + joueureuse.resistance * dt
      end
    end

    --acutalisation position du vaisseau
    joueureuse.x = joueureuse.x + joueureuse.vx * dt
    joueureuse.y = joueureuse.y + joueureuse.vy * dt

    -- test collision avec bords fenêtre
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

    -- TIRS
    -- test barre espace clavier 
    if joueureuse.chronoTir <= 0 then
      if love.keyboard.isDown('space') then
        creerTir()
        joueureuse.chronoTir = 5
      end
    else
      joueureuse.chronoTir = joueureuse.chronoTir - 10 * dt 
    end

  else

    if joueureuse.delai > 0 then
      joueureuse.delai = joueureuse.delai - dt
    else
      joueureuse.touche = false
      joueureuse.delai = DUREE_IMMOBILISATION 
    end

  end
end

-- MAJ ENNEMIS
function majEnnemis(dt)

  chronoEnnemis = chronoEnnemis - dt

  if chronoEnnemis < 0 then
    creerEnnemi(lstEnnemis)
    cmptEnnemis = cmptEnnemis + 1
    chronoEnnemis = iniChronoEnnemis- math.random(400) * dt 
  end

  for n = #lstEnnemis, 1, -1 do
    local ennemi = lstEnnemis[n]
    ennemi.x = ennemi.x + ennemi.vx * dt
    ennemi.y = ennemi.y - ennemi.vy * dt
    
    if ennemi.y - ennemi.h > HAUTEUR_ECRAN then
      table.remove(lstEnnemis, n)
    else
      if testeCollision(ennemi.x, 
                        ennemi.y, 
                        ennemi.l, 
                        ennemi.h, 
                        joueureuse.x, 
                        joueureuse.y, 
                        joueureuse.l, 
                        joueureuse.h) 
                      and ennemi.touche == false
                        then
        ennemi.touche = true
        joueureuse.touche = true
        cmptAbordages = cmptAbordages + 1
        sonExplosion:play()
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

end

-- MAJ TIRS
function majTirs(dt)

  for n = #lstTirs, 1, -1 do
    local tir = lstTirs[n]
    tir.y = tir.y + tir.vy * dt

    -- teste si tir sorti écran
    if tir.y < 0 - tir.h then
      table.remove(lstTirs,n)

    else
        
      -- alors on teste si tir touche un ennemi
      for m = #lstEnnemis, 1, -1 do
        local ennemi = lstEnnemis[m]
        if testeCollision(ennemi.x,
                          ennemi.y,
                          ennemi.l,
                          ennemi.h,
                          tir.x,
                          tir.y,
                          tir.l,
                          tir.h) then
          ennemi.touche = true
          table.remove(lstTirs, n)
          cmptAbattus = cmptAbattus + 1
          sonExplosion:play()
          break -- on sort de la boucle vu que le tir a disparu
        end
      end
    end
  end
  
end

-- UPDATE
function love.update(dt)
  
  if etatJeu == 'menu' then

    majMenu()

  elseif etatJeu == 'en jeu' then

    -- fond / scrolling

    scrolling.camera = scrolling.camera + 10 * dt
    if scrolling.camera >= scrolling.h then
      scrolling.camera = 0
    end

    -- éléments du gameplay
    majJoueureuse(dt) 

    majEnnemis(dt)
  
    majTirs(dt)
    
    if cmptEnnemis == 101 then --arrêt du jeu après le 100e ennemi
      etatJeu = 'game over'
    end

  end

end

-- ***************
-- AFFICHAGE
-- ***************
function ecrireCentre(pTexte, pHauteur)

  love.graphics.printf(pTexte, 0, pHauteur, LARGEUR_ECRAN, 'center')

end


-- AFFICHAGE MENU
function afficheMenu()

  ecrireCentre('Une salve de 100 ennemis va s’abattre sur vous. Combien en détruirez-vous ?', HAUTEUR_ECRAN/2 - 100)
  
  ecrireCentre('Appuyer sur ‘espace‘ pour lancer le jeu', HAUTEUR_ECRAN/2) 
 
  ecrireCentre('’echap‘ pour quitter le jeu à tout moment', HAUTEUR_ECRAN/2 + 50)

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

  for k, tir in ipairs(lstTirs) do
    love.graphics.draw(tir.img, tir.x, tir.y)
  end

end

-- AFFICHAGE GAME OVER
function afficheGameOver()
  
  ecrireCentre('Votre score est de : '
                ..tostring((cmptAbattus - cmptAbordages) * 100), 
                HAUTEUR_ECRAN/2 - 60)
                        
  ecrireCentre('Vous avez détruit '
                ..tostring(cmptAbattus + cmptAbordages)
                ..' ennemis sur 100, dont '
                ..tostring(cmptAbordages)
                ..' par abordage.', 
                HAUTEUR_ECRAN/2)

  ecrireCentre('Appuyez sur ‘Entrée‘ pour revenir au menu.',
               HAUTEUR_ECRAN/2 + 80)

end

-- DRAW
function love.draw()

  if etatJeu == 'menu' then
    
    afficheMenu()

  elseif etatJeu == 'en jeu' then

    --affichage fond

    love.graphics.draw(scrolling.fond, 0, 0)
    love.graphics.draw(scrolling.img, 0, scrolling.camera - scrolling.h)
    love.graphics.draw(scrolling.img,0, scrolling.camera)

    -- affichage élément gameplay

    afficheJoueureuse()
    afficheEnnemis()
    afficheTirs()

    love.graphics.print('Ennemis : '..tostring(cmptEnnemis), 10, 10)
    love.graphics.print('Abattus : '..tostring(cmptAbattus), 10, 30)
    love.graphics.print('Abordages : '..tostring(cmptAbordages), 10, 50)

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
    initJeu()
  end

  if key == 'return' and etatJeu == 'game over' then
    etatJeu = 'menu'
  end

end
