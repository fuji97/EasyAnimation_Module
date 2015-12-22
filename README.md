# EasyAnimation_Module
A module for easy animate viewports and sprites in RGSS2

This project contains:
1- EAM_Sprite: module for sprite animation
2- EAM:Viewport: module for viewport animation
3- EAM_Core: class with core functions

CREDITS:
Easing function: https://github.com/munshkr/easing-ruby/

# Documentation (only available in italian)

## Installazione
1. Inserire lo script `EAM_Core.rb`
2. Inserire gli scripts che sivogliono utilizzare sotto al precedente
3. Creare una sottoclasse del tipo che si vuole estendere ed includere il relativo modulo, es:
```ruby
class EAMSprite < Sprite
 include EAM_Sprite
end
```

## Moduli disponibili
- `EAM_Sprite` -> Estende la classe `Sprite`
- `EAM_Viewport` -> Estende la classe `Viewport`
- `EAM_SpriteComposition` -> Estende la classe `Sprite_Composition` (https://github.com/fuji97/Sprite_Composition)

## Metodi
