class Personne
  attr_accessor :nom, :points_de_vie, :en_vie

  def initialize(nom)
    @nom = nom
    @points_de_vie = 100
    @en_vie = true
  end

  def info
    # - Renvoie le nom et les points de vie si la personne est en vie
    if en_vie==true && points_de_vie>0
      return nom+ " "+points_de_vie.to_s
    # - Renvoie le nom et "vaincu" si la personne a été vaincue
    else
      puts nom+" a été vaincu!!"
      gets
      exit
    end
  end

  def attaque(personne)
    # - Fait subir des dégats à la personne passée en paramètre
     a=rand(1..20)
    personne.points_de_vie=personne.points_de_vie-a
    # - Affiche ce qu'il s'est passé
    puts nom+" attaque "+personne.nom
    puts personne.nom+" a subit des degats de #{a} hp"
  end

  def subit_attaque(degats_recus)
    # - Réduit les points de vie en fonction des dégats reçus
    points_de_vie=points_de_vie-degats_recus
    # - Affiche ce qu'il s'est passé
    puts nom+"a subit une attaque, ses points de vie sont "+points_de_vie.to_s
    # - Détermine si la personne est toujours en_vie ou non
    if points_de_vie>0
      en_vie=true
    else
      en_vie=false
    end
  end
end

class Joueur < Personne
  attr_accessor :degats_bonus

  def initialize(nom)
    # Par défaut le joueur n'a pas de dégats bonus
    @degats_bonus = 0

    # Appelle le "initialize" de la classe mère (Personne)
    super(nom)
  end

  def soin
    # - Gagner de la vie
     b=rand(1..20)
    @points_de_vie=@points_de_vie+b
    # - Affiche ce qu'il s'est passé
    puts nom+" a gagné #{b} pv"
  end

  def ameliorer_degats

    # - Augmenter les dégats bonus

     c=rand(1..20)
    @degats_bonus= @degats_bonus+c
    @points_de_vie=@points_de_vie+c
    # - Affiche ce qu'il s'est passé
    puts nom+" profite de #{c} points de degats bonus"
  end
end

class Ennemi < Personne

end

class Jeu
  def self.actions_possibles(monde)
    puts "ACTIONS POSSIBLES :"

    puts "0 - Se soigner"
    puts "1 - Améliorer son attaque"

    # On commence à 2 car 0 et 1 sont réservés pour les actions
    # de soin et d'amélioration d'attaque
    i = 2
    monde.ennemis.each do |ennemi|
      puts "#{i} - Attaquer #{ennemi.info}"
      i = i + 1
    end
    puts "99 - Quitter"
  end

  def self.est_fini(joueur, monde)

    # - Déterminer la condition de fin du jeu
  end
end

class Monde
  attr_accessor :ennemis

  def ennemis_en_vie

    # - Ne retourner que les ennemis en vie
    ennemis.each do |ennemi|
      if ennemi.en_vie==false
        ennemis.delete(ennemi)
      end
    end
  end
end

##############

# Initialisation du monde
monde = Monde.new

# Ajout des ennemis
monde.ennemis = [
  Ennemi.new("Fishu"),
  Ennemi.new("Oggy"),
  Ennemi.new("Joey")
]

# Initialisation du joueur
joueur = Joueur.new("Fatima Zahrae")

# Message d'introduction. \n signifie "retour à la ligne"
puts "\n\nAinsi débutent les aventures de #{joueur.nom}\n\n"

# Boucle de jeu principale
100.times do |tour|
  puts "\n------------------ Tour numéro #{tour} ------------------"

  # Affiche les différentes actions possibles
  Jeu.actions_possibles(monde)

  puts "\nQUELLE ACTION FAIRE ?"
  # On range dans la variable "choix" ce que l'utilisateur renseigne
  choix = gets.chomp.to_i

  # En fonction du choix on appelle différentes méthodes sur le joueur
  if choix == 0
    joueur.soin
  elsif choix == 1
    joueur.ameliorer_degats
    puts joueur.nom+" gagne en puissance!"
  elsif choix == 99
    # On quitte la boucle de jeu si on a choisi
    # 99 qui veut dire "quitter"
    break
  else
    # Choix - 2 car nous avons commencé à compter à partir de 2
    # car les choix 0 et 1 étaient réservés pour le soin et
    # l'amélioration d'attaque
    ennemi_a_attaquer = monde.ennemis[choix - 2]
    joueur.attaque(ennemi_a_attaquer)
    puts joueur.nom+" profite de 0 points de degats bonus!"
  end

  puts "\nLES ENNEMIS RIPOSTENT !"
  # Pour tous les ennemis en vie ...
  monde.ennemis_en_vie.each do |ennemi|
    # ... le héro subit une attaque.
    ennemi.attaque(joueur)
  end

  puts "\nEtat du héro: #{joueur.info}\n"

  # Si le jeu est fini, on interompt la boucle
  break if Jeu.est_fini(joueur, monde)
end

puts "\nGame Over!\n"
# - Afficher le résultat de la partie
puts "Etat du hero: "+joueur.nom+"(#{joueur.points_de_vie}/100)"
if joueur.en_vie
  puts "Vous avez gagné !"
else
  puts "Vous avez perdu !"
end
