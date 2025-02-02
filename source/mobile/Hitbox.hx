/*
 * Copyright (C) 2025 Mobile Porting Team
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

package mobile;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal.FlxTypedSignal;
import openfl.display.BitmapData;
import openfl.display.Shape;
import flixel.graphics.FlxGraphic;
import openfl.geom.Matrix;
import mobile.MobileData;
import mobile.input.MobileInputID;
import mobile.input.MobileInputManager;

class Hitbox extends MobileInputManager implements IMobileControls
{
    final offsetFir:Int = (ClientPrefs.hitboxPos ? Std.int(FlxG.height / 4) * 3 : 0);
    final offsetSec:Int = (ClientPrefs.hitboxPos ? 0 : Std.int(FlxG.height / 4));

    public var buttonLeft:TouchButton = new TouchButton(0, 0, [MobileInputID.HITBOX_LEFT, MobileInputID.NOTE_LEFT]);
    public var buttonDown:TouchButton = new TouchButton(0, 0, [MobileInputID.HITBOX_DOWN, MobileInputID.NOTE_DOWN]);
    public var buttonUp:TouchButton = new TouchButton(0, 0, [MobileInputID.HITBOX_UP, MobileInputID.NOTE_UP]);
    public var buttonRight:TouchButton = new TouchButton(0, 0, [MobileInputID.HITBOX_RIGHT, MobileInputID.NOTE_RIGHT]);
    public var buttonExtra:TouchButton = new TouchButton(0, 0, [MobileInputID.EXTRA_1]); // Fixed missing parenthesis
    public var buttonExtra2:TouchButton = new TouchButton(0, 0, [MobileInputID.EXTRA_2]); // Fixed missing parenthesis

    public var instance:MobileInputManager;
    public var onButtonDown:FlxTypedSignal<TouchButton->Void> = new FlxTypedSignal<TouchButton->Void>();
    public var onButtonUp:FlxTypedSignal<TouchButton->Void> = new FlxTypedSignal<TouchButton->Void>();

    var storedButtonsIDs:Map<String, Array<MobileInputID>> = new Map<String, Array<MobileInputID>>();

    public function new(?extraMode:ExtraActions = NONE)
    {
        super();

        for (button in Reflect.fields(this))
        {
            var field = Reflect.field(this, button);
            if (Std.isOfType(field, TouchButton))
                storedButtonsIDs.set(button, Reflect.getProperty(field, 'IDs'));
        }

        switch (extraMode)
        {
            case NONE:
                add(buttonLeft = createHint(0, 0, Std.int(FlxG.width / 4), FlxG.height, 0xFFC24B99));
                add(buttonDown = createHint(FlxG.width / 4, 0, Std.int(FlxG.width / 4), FlxG.height, 0xFF00FFFF));
                add(buttonUp = createHint(FlxG.width / 2, 0, Std.int(FlxG.width / 4), FlxG.height, 0xFF12FA05));
                add(buttonRight = createHint((FlxG.width / 2) + (FlxG.width / 4), 0, Std.int(FlxG.width / 4), FlxG.height, 0xFFF9393F));
            
            case SINGLE:
                add(buttonExtra = createHint(0, offsetFir, FlxG.width, Std.int(FlxG.height / 4), 0xFF0066FF));
            
            case DOUBLE:
                add(buttonExtra2 = createHint(Std.int(FlxG.width / 2), offsetFir, Std.int(FlxG.width / 2), Std.int(FlxG.height / 4), 0xA6FF00));
                add(buttonExtra = createHint(0, offsetFir, Std.int(FlxG.width / 2), Std.int(FlxG.height / 4), 0xFF0066FF));
        }

        storedButtonsIDs.clear();
        scrollFactor.set();
        updateTrackedButtons();

        instance = this;
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        // Press spacebar when buttonExtra is pressed
        if (buttonExtra.pressed)
        {
            FlxG.keys.press.FlxKey.SPACE;
        }
    }

    override function destroy()
    {
        super.destroy();
        FlxDestroyUtil.destroy(onButtonUp);
        FlxDestroyUtil.destroy(onButtonDown);
    }
	}
