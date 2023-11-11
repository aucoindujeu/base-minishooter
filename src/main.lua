-- **********************************
-- Variables utilisées dans le jeu
-- *********************************

-- Constantes
LARGEUR_ECRAN = 800
HAUTEUR_ECRAN = 600

etatJeu = 'menu'

-- Sprite Joueur
joueureuse = {}
joueureuse.img = love.graphics.newImage('images/joueureuse.png')
joueureuse.imgExplosion = love.graphics.newImage('images/explosion.png')
joueureuse.l = joueureuse.img:getWidth()
joueureuse.h = joueureuse.img:getHeight()
joueureuse.x = 0 
joueureuse.y = 0 

-- Sprites Ennemis

lstEnnemis = {}

-- Tirs

lstTirs = {}

-- *****************
-- Fonctions
-- *****************

-- test collision méthode bounding boxes
function testeCollision(pX1, pY1, pL1, pH1, pX2, pY2, pL2, pH2)

  return pX1 < pX2 + pL2 and pX2 < pX1 + pL1 and pY1 < pY2 + pH2 and pY2 < pY1 + pH1

end

-- ****************************
-- INITIALISATION DE LA PARTIE
-- ****************************

function initJeu()
  
  joueureuse.x = (LARGEUR_ECRAN - joueureuse.l)/2
  joueureuse.y = HAUTEUR_ECRAN - joueureuse.h * 2

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

function majMenu()

end


function majJoueureuse(dt)

end


function majEnnemis(dt)
end


function majTirs(dt)
end


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

function afficheMenu()

  love.graphics.printf('appuyer sur `espace` pour lancer le jeu',
                        0,
                        HAUTEUR_ECRAN/2,
                        LARGEUR_ECRAN,
                        'center')

end


function afficheJoueur()

  love.graphics.draw(joueureuse.img, joueureuse.x, joueureuse.y)

end


function afficheEnnemis()
end


function afficheTirs()
end


function afficheGameOver()

end


function love.draw()

  if etatJeu == 'menu' then
    
    afficheMenu()

  elseif etatJeu == 'en jeu' then

    afficheJoueur()
    afficheEnnemis()
    afficheTirs()

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
