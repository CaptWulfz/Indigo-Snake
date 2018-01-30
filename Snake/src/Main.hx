package;

import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.events.KeyboardEvent;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.net.SharedObject;
import openfl.Lib;
/**
 * ...
 * @author Jesin Jarod Martinez
 */
class Main extends Sprite 
{
	private var so:SharedObject;
	
	private var currTime:Float;
	private var prevTime:Float;
	private var deltaTime:Float;
	private var dt:Float;
	
	private var mainGrid:Array<Array<Sprite>>;
	private var gridCols:Int = 20;
	private var gridRows:Int = 20;
	private var headRow:Float;
	private var headCol:Float;
	
	private var startScreen:StartScreen;
	private var gameOverScreen:GameOverScreen;
	
	private var currGameState:GameState;
	private var playing:Bool;
	
	private var snake:Array<Snake>;
	private var startLength:Int = 4;
	private var currDir:Direction;
	
	private var format:TextFormat;
	private var scoreField:TextField;
	private var score:Int = 0;
	private var highScore:Int = 0;
	
	private var food:Food;
	
	private var speed:Float;
	
	public function init():Void{
		
		connect();
		
		// Grid Initalization
		mainGrid = [for (x in 0...gridRows) [for (y in 0... gridCols) null]];
		
		speed = 15;
		
		playing = false;
		
		currTime = 0;
		prevTime = 0;
		
		//Player Instantiation
		snake = new Array<Snake>();
		
		headRow = (gridRows / 2 - 1);
		headCol = (gridCols / 2 - 1);
		
		for (i in 0 ... startLength){
			snake.push(new Snake(headCol * 20 - (20 * i), headRow * 20));
		}
		
		
		//Start Screen Instantiation
		startScreen = new StartScreen();
		startScreen.x = (stage.stageWidth - startScreen.width) / 2;
		startScreen.y = (stage.stageHeight - startScreen.height) / 2;
		
		//Text Format Creation
		format = new TextFormat();
		format.font = "Arial";
		format.size = 24;
		format.align = CENTER;
		format.color = 0xFFFFFFFF;
		
		//Text Field Initialization
		scoreField = new TextField();
		scoreField.border = false;
		scoreField.background = false;
		scoreField.x = 0;
		scoreField.y = 0;
		scoreField.width = 150;
		scoreField.text = "Score: " + score;
		scoreField.setTextFormat(format);
		
		//Game Over Screen Initialization
		gameOverScreen = new GameOverScreen();
		gameOverScreen.x = (stage.stageWidth - startScreen.width) / 2;
		gameOverScreen.y = (stage.stageHeight - startScreen.height) / 2; 
		
		//Food Initialization
		food = new Food();
		setFoodPosition();
		
		//Set GameState
		setGameState(Title);
	}
	
	public function connect():Void{
		so = SharedObject.getLocal("snakeScore");
		
		if (so.data.highScore != null)
			highScore = so.data.highScore;
		else 
			highScore = 0;
	}
	
	public function setPlayStage():Void{
		playing = true;
		
		this.addChild(food);
		this.addChild(scoreField);
		
		for (i in 0 ... snake.length){
			this.addChild(snake[i]);
		}
		
		colorSnake();
		
		setGameState(Playing);
	}
	
	public function showStartScreen(){
		this.addChild(startScreen);
	}
	
	public function new() 
	{
		super();
		init();
	}

	public function setGameState(state:GameState):Void{
		currGameState = state;
		if (currGameState == Title){
			showStartScreen();
			stage.addEventListener(MouseEvent.CLICK, pickDifficulty);
		} else if (currGameState == Playing) {
			playing = true;
			currDir = Right;
			prevTime = Lib.getTimer();
			stage.focus = stage;
			this.addEventListener(Event.ENTER_FRAME, gameLoop);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, changeDirection);
		} else if (currGameState == GameOver) {
			playing = false;
			
			if (highScore < score)
				highScore = score;
				
			this.addChild(gameOverScreen);
			gameOverScreen.setScore(score, highScore);
			setFoodPosition();
			
			so.data.highScore = highScore;
			so.flush();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, resetGame);
		}
	}
	
	public function removeTitleListeners(){
		stage.removeEventListener(MouseEvent.CLICK, pickDifficulty);
	}
	
	public function removePlayingListeners(){
		this.removeEventListener(Event.ENTER_FRAME, gameLoop);
		stage.removeEventListener(KeyboardEvent.KEY_DOWN, changeDirection);
	}
	
	public function removeGameOverListeners(){
		stage.removeEventListener(KeyboardEvent.KEY_DOWN, resetGame);
	}
	
	//Game Loop
	public function gameLoop(event:Event): Void {
		
		var prevHeadX:Float = 0;
		var prevHeadY:Float = 0;
		var snakeHead:Snake = snake[0];
		
		currTime = Lib.getTimer();
			
		deltaTime = (currTime - prevTime) / 1000;
		
		dt += deltaTime;
		
		if (playing && dt > speed) {

			dt -= speed;
			
			prevTime = currTime;
			
			if (currDir == Right){
				headRow++;
			} else if (currDir == Left){
				headRow--;
			} else if (currDir == Up){
				headCol--;
			} else if (currDir == Down) {
				headCol++;
			}
			
		
			for (i in 1 ... snake.length){
				if (headRow * 20 == snake[i].x && headCol * 20 == snake[i].y){
					removePlayingListeners();
					setGameState(GameOver);
				}
			}
			
				
			if (headRow * 20 <= stage.x - 10 ||
				headRow * 20 + snakeHead.width >= (mainGrid.length) * 20 ||
				headCol * 20 <= stage.y - 10||
				headCol * 20 + snakeHead.height >= (mainGrid.length) * 20){
					removePlayingListeners();
					setGameState(GameOver);
				}
				
			if (headRow * 20 <= food.x + food.width &&
				headRow * 20 + snakeHead.width >= food.x &&
				headCol * 20 <= food.y + food.height &&
				headCol * 20 + snakeHead.width >= food.y){
					
					setFoodPosition();
					
					var newHead = new Snake(prevHeadX, prevHeadY);
					snake.push(newHead);
					this.addChild(newHead);
					
					score += 10;
					scoreField.text = "Score: " + score;
				} 
					
				var newHead:Snake = snake.pop();
				prevHeadX = newHead.x;
				prevHeadY = newHead.y;
				newHead.x = headRow * 20;
				newHead.y = headCol * 20;
				
				snake.unshift(newHead);	
			
				colorSnake();	
		}
		
	}
	
	public function colorSnake():Void{
		for (i in 0 ... snake.length){
			if (i == 0)
				snake[i].graphics.beginFill(0x8db600);
			else {
				snake[i].graphics.beginFill(0x4b5320);
			}
			snake[i].graphics.drawRect(0, 0, 15, 15);
		}
	}
	
	public function setFoodPosition(){
		food.x = (Math.floor((Math.random() * mainGrid.length - 1) + 1)) * 20;
		food.y = (Math.floor((Math.random() * mainGrid.length - 1) + 1)) * 20;
	}
	
	//Title State Event Functions
	public function pickDifficulty(event:MouseEvent): Void {
		var clickX = event.stageX;
		var clickY = event.stageY;
		var ready:Bool = false;
		
		var easy:TextField = startScreen.getChoiceArray()[0];
		var normal:TextField = startScreen.getChoiceArray()[1];
		var hard:TextField = startScreen.getChoiceArray()[2];
		
		
		if (clickX >= easy.x + easy.parent.x &&
			clickX <= easy.x + easy.width  + easy.parent.x &&
			clickY >= easy.y + easy.parent.y &&
			clickY <= easy.y + easy.height + easy.parent.y){
			speed = 15;
			ready = true;
		}
		
		if (clickX >= normal.x + normal.parent.x &&
			clickX <= normal.x + normal.width + normal.parent.x &&
			clickY >= normal.y + normal.parent.y &&
			clickY <= normal.y + normal.height + normal.parent.y){
			speed /= 2;
			ready = true;
		}
			
		
		if (clickX >= hard.x + hard.parent.x &&
			clickX <= hard.x + hard.width + hard.parent.x &&
			clickY >= hard.y + hard.parent.y &&
			clickY <= hard.y + hard.height + hard.parent.y) {
			speed /= 3;
			ready = true;
		}
		
		if (ready) {
			this.removeChildren(0, this.numChildren - 1);
			removeTitleListeners();
			setPlayStage();
		}
	}
	
	//Playing State Event Functions
	public function changeDirection(event:KeyboardEvent):Void{
		var code = event.keyCode;
		var up = 38, down = 40, left = 37, right = 39;
		
		if (code == up && currDir != Down) {
			currDir = Up;
		} else if (code == down && currDir != Up) {
			currDir = Down;
		} else if (code == left && currDir != Right) {
			currDir = Left;
		} else if (code == right && currDir != Left) {
			currDir = Right;
		}

	}
	

	
	//GameOver State EventFunction
	public function resetGame(event:KeyboardEvent): Void {
		var code = event.keyCode;
		var R = 82;
		
		if (code == R) {
			
			var toRemove:Array<Snake> = snake.splice(startLength, snake.length - startLength);
			
			for (i in 0 ... toRemove.length)
				this.removeChild(toRemove[i]);
			
			headRow = (gridRows / 2 - 1);
			headCol = (gridCols / 2 - 1);
			
			for (i in 0 ... snake.length){
				snake[i].x = headCol * 20 - (20 * i);
				snake[i].y = headRow * 20;
			}
			score = 0;
			scoreField.text = "Score: "  + score;
			
			this.removeChild(gameOverScreen);
			removeGameOverListeners();
			
			setGameState(Playing);
		}
	}
}
