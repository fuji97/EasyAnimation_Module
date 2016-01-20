# EasyAnimation_Module
A module for easy animate viewports and sprites in RGSS2

This project contains:
1. EAM_Sprite: module for sprite animation
2. EAM:Viewport: module for viewport animation
3. EAM_Core: class with core functions

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
### Metodi per le animazioni
##### move(x,y,frame,ease=:linear_tween,callback=nil)
Anima il movimento di un oggetto verso un punto a scelta  
`x` - Coordinate della posizione di destinazione (Ascissa)  
`y` - Coordinate della posizione di destinazione (Ordinata)  
`frame` - Durata dell'animazione (in frame)  
`ease` - Tipo di ease, di default è `linear_tween`  
`callback` - Definisce un metodo da chiamare al termine dell'animazione (callback), di default è nullo  

##### curveMove(angle,frame,ease=:linear_tween,callback=nil)
Anima il movimento di un oggetto attorno a un punto (movimento circolare), per utilizzarlo è necessario impostare il punto centrale con `setCircPoint(x,y)`  
`angle` - Angolo espresso in gradi  
`frame` - Durata dell'animazione (in frame)  
`ease` - Tipo di ease, di default è `linear_tween`  
`callback` - Definisce un metodo da chiamare al termine dell'animazione (callback), di default è nullo  

##### moveCirc(cX,cY,frame,ease=:linear_tween,callback=nil)
Anima il movimento del punto centrale utilizzato da `curveMove`  
`x` - Coordinate della posizione di destinazione (Ascissa)  
`y` - Coordinate della posizione di destinazione (Ordinata)  
`frame` - Durata dell'animazione (in frame)  
`ease` - Tipo di ease, di default è `linear_tween`  
`callback` - Definisce un metodo da chiamare al termine dell'animazione (callback), di default è nullo  

##### animateRadius(length,frame,ease=:linear_tween,callback=nil)
Anima la lunghezza del raggio utilizzato da `curveMove`  
`length` - Lunghezza del raggio (in pixel)  
`frame` - Durata dell'animazione (in frame)  
`ease` - Tipo di ease, di default è `linear_tween`  
`callback` - Definisce un metodo da chiamare al termine dell'animazione (callback), di default è nullo  

##### fade(opacity,frame,ease=:linear_tween,callback=nil)
Anima l'opacità di un oggetto  
`opacity` - Opacità finale (espresso da 0 a 255)  
`frame` - Durata dell'animazione (in frame)  
`ease` - Tipo di ease, di default è `linear_tween`  
`callback` - Definisce un metodo da chiamare al termine dell'animazione (callback), di default è nullo  

##### zoom(x,y,frame,ease=:linear_tween,callback=nil)
Anima lo zoom di un oggetto  
`x` - Zoom sull'ascissa (1.0 è il valore di default)
`y` - Zoom sull'ordinata (1.0 è il valore di default) 
`frame` - Durata dell'animazione (in frame)  
`ease` - Tipo di ease, di default è `linear_tween`  
`callback` - Definisce un metodo da chiamare al termine dell'animazione (callback), di default è nullo  

##### rotate(angle,frame,ease=:linear_tween,callback=nil)
Anima la rotazione di un oggetto  
`angle`- Angolo della posizione finale espresso in gradi (l'uso di valori superiori a 360° causerà giri multipli)
`frame` - Durata dell'animazione (in frame)  
`ease` - Tipo di ease, di default è `linear_tween`  
`callback` - Definisce un metodo da chiamare al termine dell'animazione (callback), di default è nullo  

##### coloring(mColor,frame,ease=:linear_tween,callback=nil)
Anima la colorazione di un oggetto  
`mColor` - Oggetto di classe `Color` con la colorazione finale
`frame` - Durata dell'animazione (in frame)  
`ease` - Tipo di ease, di default è `linear_tween`  
`callback` - Definisce un metodo da chiamare al termine dell'animazione (callback), di default è nullo 

### Metodi di settaggio
##### setRotationPoint(x,y)
Imposta il punto di rotazione su cui l'oggetto effettua la rotazione (corrisponde a impostare i valori `ox` e `oy` solo per la rotazione), se usato bisogna richiamare `postUpdate` dopo `Graphics.update`  
NB: Non si può utilizzarlo in contemporanea a `setZoomPoint`  
`x` - Coordinate dell'asse X  
`y` - Coordinate dell'asse Y  

##### unsetRotationPoint()
Disattiva il punto di rotazione (utilizza i valori di `ox` e `oy` impostati sull'oggetto)  

##### setZoomPoint(x,y)
Imposta il punto da cui effettuare lo zoom (corrisponde a impostare i valori `ox` e `oy` solo per la lo zoom), se usato bisogna richiamare `postUpdate` dopo `Graphics.update`  
NB: Non si può utilizzarlo in contemporanea a `setRotationPoint`  
`x` - Coordinate dell'asse X  
`y` - Coordinate dell'asse Y  

##### setCircPoint(x,y)
Imposta il punto centrale utilizzato da `circMove`  
`x` - Coordinate dell'asse X  
`y` - Coordinate dell'asse Y 

### Metodi di aggiornamento
##### update()
Effettua tutte le animazioni impostate (avanti di un frame), di norma, da chiamare sempre prima di `Graphics.update`  

##### postUpdate()
Ripristina i valori di `ox` e `oy` originali, da richiamare solitamente dopo il `Graphics.update` se si utilizza `setRotationPoint` o `setZoomPoint`  
