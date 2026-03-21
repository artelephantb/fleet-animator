# Fleet Animator
Fleet Animator is an animation application for creating motion graphics. Unlike other animation programs, Fleet Animator uses node graphs.

## Sprites
In many other animation programs, they usually use *layers*; but this is different from Fleet Animator, which uses sprites instead. Sprites can have positional information, scale information, or more. These properties control how the sprite acts and behaves.

### Sprites Panel
Sprites are seen in the `Sprite Panel` on the left. Sprites can be created by pressing the `+ Sprite` button at the bottom of the panel. Clicking on a sprite in the panel will select the sprite. Sprites can be renamed by clicking on the selected sprite's name.

### Inspector Panel
A sprite's properties can be accessed and edited by using the `Inspector Panel` on the right. These properties will change depending on the selected sprite.

### Components
Animation of a sprite can be created by using *components*. Components are used at the `Component Graph` located at the bottom.

Pressing the *Add Component* button shows a popup for adding a component. Double clicking one of these, or by pressing the *Select* button will create an instance of that component on the graph.

Components can be connected by the connection points located on either side of a component (Note that some components do not have connection points).

All sprites that are to be animated need to start with one or more `On Start Event` component(s); This component is ran first and will run the trailing components connected to it.

## License
Fleet Animator is under the [MIT license](LICENSE.txt)

## Attribution
- [curve_editor.gd](scripts/curve_editor.gd) - Adapted from [godot_curve_editor](https://github.com/JtotheThree/godot_curve_editor) - Copyright (c) 2024 JtotheThree, licensed under the [MIT license](https://github.com/JtotheThree/godot_curve_editor/blob/main/LICENSE)
