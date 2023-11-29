# GDSscript Basics

- [GDSscript Basics](#gdsscript-basics)
  - [Base de la programmation](#base-de-la-programmation)
  - [Godot et GDScript](#godot-et-gdscript)
    - [Syntaxe Python](#syntaxe-python)
    - [Syntaxe GDScript](#syntaxe-gdscript)
    - [Programmation Orientée Objet](#programmation-orientée-objet)
    - [GDScript](#gdscript)


## Base de la programmation

Pour avoir un code plus facilement lisible par les autres et par soi-même, il est important de :
- Nommer ses variables, fonctions et classes de façon cohérente à son utilisation
- Respecter qu'une fonction ne doit remplir qu'une seule tâche, si elle commence à remplir 2, le code doit être séparé
- Alléger la lecture du code en mettant des formes (espaces, lignes vides pour séparer des paragraphes etc...)
- Faire attention au niveau de complexité du code, **plus c'est simple, mieux c'est**
- Aller vérifier la documentation des outils qu'on utilise ! **C'est la règle d'or du développement !**

## Godot et GDScript

Le GDScript est un langage de programmation spécialement créé par des développeurs de jeux vidéo pour des développeurs de jeux vidéo et Godot.  
La syntaxe est basé sur celle de Python.

### Syntaxe Python

Petite piqûre de rappel :
- Comparé aux autres langages, on ne doit pas mettre le `;` en fin de ligne ou d'instruction
- Pas de `{}` pour encadrer des blocs de codes, Python se base sur l'indentation
- `:` en fin de fonction ou condition
- `def` pour faire des fonctions

Exemple rapide :
```py
def tenCount():
    count = 1
    threshold = 10

    if count < threshold:
        print(count)
        count =+ 1 
    
tenCount()
```

### Syntaxe GDScript

GDScript est certes basé sur Python pour sa syntaxe mais elle n'est pas totalement pareil :
- `func` est utilisé pour les fonctions et non `def`
- Doit inclure `var` devant le nom d'une variable ou `const` pour une constante
- (Plus technique mais important) Types dynamiques (Exemple : var myVar = 10 et derrière, on peut appliquer myVar = "test") mais possibilité de rendre statique

Petit exemple :

```py
func tenCount():
    var count = 1
    const threshold = 10

    if count < threshold:
        print(count)
        count =+ 1 
    
tenCount()

# Plus technique avec un typage statique
func tenCount() -> void:
    var count : int = 1
    const threshold : int = 10

    if count < threshold:
        print(count)
        count =+ 1 
    
tenCount()
```

### Programmation Orientée Objet

Le GDScript est un langage de programmation utilisant la Programmation Orientée Objet (POO ou OOP en anglais)
La POO est un paradigme de programmation, [voici un court résumé](/doc/POO.md) mais en voici la conclusion :
```
En résumé, la POO permet de structurer le code de manière à le rendre plus compréhensible et réutilisable en organisant les fonctionnalités en objets, et en utilisant des concepts comme l'encapsulation, l'héritage, le polymorphisme, et l'abstraction. Cela rend le développement de logiciels plus modulaire et efficace.
```

### GDScript

Godot va beaucoup utiliser le système d'héritage car nos objets vont partir de classe déjà définies par Godot  
Cet héritage nous permettra d'utiliser les variables et fonctions autorisées par la classe mère, ça nous évite de réinventer la roue  
Une documentation sera présente pour nous aider à comprendre ce qu'on peut faire avec

Godot fonctionne avec un système de noeud qui permet de connecter plusieurs objets et de les faire communiquer en appellant des fonctions chez l'un et l'autre
Typiquement, j'ai un objet Timer qui, à la fin d'un temps doit passer une information, je vais créer un noeud sur lui et y connecter l'autre objet

Il va donc m'être difficile de te donner un exemple facile et concret de code car je n'ai pas assez exploré Godot et ce qu'il fournit
Pour notre niveau, ce qui va être important est de savoir réfléchir logiquement et travailler avec la documentation pour arriver à nos fins

Pour quand même te donner une idée d'un code commenté de SBM :
```py
extends CharacterBody2D # Définition de la classe mère

# Définition des variables changeables dans Godot
@export var speed : int = 1200
@export var jump_speed : int = -1800
@export var gravity : int = 4000
@export var down_speed : int = 600
@export var sprint_speed : int = 300
@export var jumps_off_floor : int = 1
@export var player_index : int = 1

# Définition des variables
var jumps = jumps_off_floor
var isRed = true

# Fonction récupérant les entrées du joueur
func get_input():
	var isSprinting : bool = Input.is_action_pressed("sprint_%s" % [player_index])
	velocity.x = 0
	if Input.is_action_pressed("move_right_%s" % [player_index]):
		velocity.x += speed + sprint_speed if isSprinting else speed
	if Input.is_action_pressed("move_left_%s" % [player_index]):
		velocity.x -= speed + sprint_speed if isSprinting else speed
	if Input.is_action_pressed("move_down_%s" % [player_index]):
		velocity.y += down_speed

# Fonction qui redonne des sauts au joueur si il touche le sol
func refill_jumps_off_floor():
	if is_on_floor():
		jumps = jumps_off_floor

# Override de la fonction mère qui s'exécute lors de calcul de physique
func _physics_process(delta):
	refill_jumps_off_floor()
	get_input()
	velocity.y += gravity * delta
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
	velocity = velocity
	if Input.is_action_just_pressed("jump_%s" % [player_index]):
		if is_on_floor():
			velocity.y = jump_speed
		elif jumps > 0:
			velocity.y = jump_speed
			jumps-=1

# Fonction qui est appelé par un autre objet via un noeud pour changer le sprite du cube
func _on_BPMTimer_timeout():
	if isRed:
		$Sprite2D.texture = load("res://assets/sprites/characters/player1/Player1.png")
		isRed=false
	else:
		$Sprite2D.texture = load("res://assets/sprites/characters/player2/Player2.png")
		isRed=true

# Fonction qui définit le comportement quand le joueur touche une limite de map
func hit_blast_zone():
	var screen_size = get_viewport_rect().size
	position = Vector2(screen_size.x/2, screen_size.y/6)
	print("Vous êtes morts :(")

# Fonction qui est appelé par les limites de la map
func _on_LimitDown_hit_blast_zone():
	hit_blast_zone()

func _on_LimitTop_hit_blast_zone():
	hit_blast_zone()

func _on_LimitLeft_hit_blast_zone():
	hit_blast_zone()

func _on_LimitRight_hit_blast_zone():
	hit_blast_zone()
```

Comme tu peux rapidement le voir, j'utilise des Vector2D qui sont est une classe de Godot ou encore faire référence à des éléments de mon perso comme `$Sprite2D.texture`