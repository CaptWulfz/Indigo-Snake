package;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * ...
 * @author Jesin Jarod Martinez
 */
class GameOverScreen extends Sprite
{
	private var gameOver:TextField;
	private var highScoreField:TextField;
	private var currScoreField:TextField;
	private var format:TextFormat;
	
	public var currScore:Int = 0;
	public var highScore:Int = 0;
	
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
		
		
		//Game Over Creation
		gameOver = new TextField();
		gameOver.background = false;
		gameOver.border = false;
		gameOver.x = this.x + (gameOver.width / 2);
		gameOver.y = 30;
		gameOver.width = 300;
		gameOver.height = 100;
		gameOver.wordWrap = true;
		gameOver.text = "GAME OVER";
		gameOver.setTextFormat(format);
		
		//High Score Creation
		highScoreField = new TextField();
		highScoreField.background = false;
		highScoreField.border = false;
		highScoreField.x = this.x + (gameOver.width / 6);
		highScoreField.y = gameOver.y + 180;
		highScoreField.width = 300;
		highScoreField.height = 100;
		highScoreField.wordWrap = true;
		highScoreField.text = "High Score: " + highScore;
		highScoreField.setTextFormat(format);
		
		//Curr score Creation
		currScoreField = new TextField();
		currScoreField.background = false;
		currScoreField.border = false;
		currScoreField.x = (this.x + gameOver.width / 6);
		currScoreField.y = highScoreField.y + 60;
		currScoreField.width = 300;
		currScoreField.height = 100;
		currScoreField.wordWrap = true;
		currScoreField.text = "Current Score: " + currScore;
		currScoreField.setTextFormat(format);
		
		
		//Adding Children
		this.addChild(gameOver);
		this.addChild(highScoreField);
		this.addChild(currScoreField);
	}
	
	public function setScore(currScore:Int, highScore:Int):Void{
		this.currScore = currScore;
		this.highScore = highScore;
		
		this.highScoreField.text = "High Score: " + highScore;
		this.currScoreField.text = "Current Score: " + currScore;
	}
	
}