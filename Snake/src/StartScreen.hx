package;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * ...
 * @author Jesin Jarod Martinez
 */
class StartScreen extends Sprite
{
	private var choiceArray:Array<Choice>;
	private var noChoices:Int = 3;
	
	private var title:TextField;
	private var format:TextFormat;
	
	public function new() 
	{
		super();
		
		//Screen Creation
		this.graphics.beginFill(0xD3D3D3);
		this.graphics.drawRect(0, 0, 400, 400);
		this.graphics.endFill();
		
		//Format Creation
		format = new TextFormat();
		format.font = "Arial";
		format.size = 24;
		format.align = CENTER;
		
		
		//Title Creation
		title = new TextField();
		title.background = false;
		title.border = false;
		title.x = this.x + (title.width / 2);
		title.y = 30;
		title.width = 300;
		title.height = 100;
		title.wordWrap = true;
		title.text = "SNAKE";
		title.setTextFormat(format);
		
		//Choices Creation
		choiceArray = new Array<Choice>();
		for (i in 0 ... noChoices){
			var choice:Choice = new Choice();
			
			if (i == 0)
				choice.text = "Easy";
			else if (i == 1)
				choice.text = "Normal";
			else if (i == 2)
				choice.text = "Hard";
			
			choice.setTextFormat(format);
			choiceArray.push(choice);
		}
		setChoicesPosition();
		
		//Adding Children
		this.addChild(title);
		for (i in 0 ... choiceArray.length)
			this.addChild(choiceArray[i]);
	}
	
	private function setChoicesPosition():Void{
		for (i in 0 ... choiceArray.length){
			choiceArray[i].x = (this.width - choiceArray[i].width) / 2;
			
			if ( i == 0)
				choiceArray[i].y = title.y + 150;
			else
				choiceArray[i].y = choiceArray[i - 1].y + 80;
		}
	}
	
	//Getters
	public function getChoiceArray():Array<Choice>{
		return this.choiceArray;
	}
}