package avdw.playground.minesweeper {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class Main extends Sprite {
		private var grid:Vector.<Vector.<Cell>>;
		
		public function Main():void {
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			var rows:int = 10, cols:int = 10;
			grid = createZeroMatrix(rows, cols);
			scatterMines(grid, 10);
			calcNumbers(grid);
			
			var gridContainer:Sprite = new Sprite();
			var i:int, j:int;
			for (i = 0; i < rows; i++) {
				for (j = 0; j < cols; j++) {
					grid[i][j].x = j * GraphicAsset.CellEmpty.width;
					grid[i][j].y = i * GraphicAsset.CellEmpty.height;
					grid[i][j].col = j;
					grid[i][j].row = i;
					gridContainer.addChild(grid[i][j]);
				}
			}
			
			addChild(gridContainer);
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent):void {
			var cell:Cell = e.target as Cell;
			if (cell.type == ECell.Empty && cell.isVisible()) {
				floodfill(cell, grid);
			}
		}
		
		private function floodfill(cell:Cell, grid:Vector.<Vector.<Cell>>):void {
			var rows:int = grid.length;
			var cols:int = grid[0].length;
			var queue:Vector.<Cell> = new Vector.<Cell>();
			queue.push(cell);
			
			var tmp:Cell;
			while (queue.length != 0 && queue.length < rows * cols) {
				tmp = queue.shift();
				tmp.show();
				// top row
				if (tmp.row - 1 >= 0) {
					// top left
					if (tmp.col - 1 >= 0) {
						if (!grid[tmp.row - 1][tmp.col - 1].isVisible()) {
							if (grid[tmp.row - 1][tmp.col - 1].type == ECell.Empty) {
								if (queue.indexOf(grid[tmp.row - 1][tmp.col - 1]) == -1) {
									queue.push(grid[tmp.row - 1][tmp.col - 1]);
								}
							} else {
								grid[tmp.row - 1][tmp.col - 1].show();
							}
						}
					}
					// top center
					if (!grid[tmp.row - 1][tmp.col].isVisible()) {
						if (grid[tmp.row - 1][tmp.col].type == ECell.Empty) {
							if (queue.indexOf(grid[tmp.row - 1][tmp.col]) == -1) {
								queue.push(grid[tmp.row - 1][tmp.col]);
							}
						} else {
							grid[tmp.row - 1][tmp.col].show();
						}
					}
					// top right
					if (tmp.col + 1 < cols) {
						if (!grid[tmp.row - 1][tmp.col + 1].isVisible()) {
							if (grid[tmp.row - 1][tmp.col + 1].type == ECell.Empty) {
								if (queue.indexOf(grid[tmp.row - 1][tmp.col + 1]) == -1) {
									queue.push(grid[tmp.row - 1][tmp.col + 1]);
								}
							} else {
								grid[tmp.row - 1][tmp.col + 1].show();
							}
						}
					}
				}
				// center left
				if (tmp.col - 1 >= 0) {
					if (!grid[tmp.row][tmp.col - 1].isVisible()) {
						if (grid[tmp.row][tmp.col - 1].type == ECell.Empty) {
							if (queue.indexOf(grid[tmp.row][tmp.col - 1]) == -1) {
								queue.push(grid[tmp.row][tmp.col - 1]);
							}
						} else {
							grid[tmp.row][tmp.col - 1].show();
						}
					}
				}
				// center right
				if (tmp.col + 1 < cols) {
					if (!grid[tmp.row][tmp.col + 1].isVisible()) {
						if (grid[tmp.row][tmp.col + 1].type == ECell.Empty) {
							if (queue.indexOf(grid[tmp.row][tmp.col + 1]) == -1) {
								queue.push(grid[tmp.row][tmp.col + 1]);
							}
						} else {
							grid[tmp.row][tmp.col + 1].show();
						}
					}
				}
				// bottom row
				if (tmp.row + 1 < rows) {
					// bottom left
					if (tmp.col - 1 >= 0) {
						if (!grid[tmp.row + 1][tmp.col - 1].isVisible()) {
							if (grid[tmp.row + 1][tmp.col - 1].type == ECell.Empty) {
								if (queue.indexOf(grid[tmp.row + 1][tmp.col - 1]) == -1) {
									queue.push(grid[tmp.row + 1][tmp.col - 1]);
								}
							} else {
								grid[tmp.row + 1][tmp.col - 1].show();
							}
						}
					}
					// bottom center
					if (!grid[tmp.row + 1][tmp.col].isVisible()) {
						if (grid[tmp.row + 1][tmp.col].type == ECell.Empty) {
							if (queue.indexOf(grid[tmp.row + 1][tmp.col]) == -1) {
								queue.push(grid[tmp.row + 1][tmp.col]);
							}
						} else {
							grid[tmp.row + 1][tmp.col].show();
						}
					}
					// bottom right
					if (tmp.col + 1 < cols) {
						if (!grid[tmp.row + 1][tmp.col + 1].isVisible()) {
							if (grid[tmp.row + 1][tmp.col + 1].type == ECell.Empty) {
								if (queue.indexOf(grid[tmp.row + 1][tmp.col + 1]) == -1) {
									queue.push(grid[tmp.row + 1][tmp.col + 1]);
								}
							} else {
								grid[tmp.row + 1][tmp.col + 1].show();
							}
						}
					}
				}
			}
		}
		
		private function calcNumbers(grid:Vector.<Vector.<Cell>>):void {
			var rows:int = grid.length;
			var cols:int = grid[0].length;
			
			var surroundingMines:int;
			var i:int, j:int;
			for (i = 0; i < rows; i++) {
				for (j = 0; j < cols; j++) {
					if (grid[i][j].type == ECell.Empty) {
						surroundingMines = 0;
						surroundingMines += (i - 1 >= 0 && j - 1 >= 0 && grid[i - 1][j - 1].type == ECell.Mine) ? 1 : 0;
						surroundingMines += (i - 1 >= 0 && grid[i - 1][j + 0].type == ECell.Mine) ? 1 : 0;
						surroundingMines += (i - 1 >= 0 && j + 1 < cols && grid[i - 1][j + 1].type == ECell.Mine) ? 1 : 0;
						surroundingMines += (j - 1 >= 0 && grid[i + 0][j - 1].type == ECell.Mine) ? 1 : 0;
						surroundingMines += (j + 1 < cols && grid[i + 0][j + 1].type == ECell.Mine) ? 1 : 0;
						surroundingMines += (i + 1 < rows && j - 1 >= 0 && grid[i + 1][j - 1].type == ECell.Mine) ? 1 : 0;
						surroundingMines += (i + 1 < rows && grid[i + 1][j + 0].type == ECell.Mine) ? 1 : 0;
						surroundingMines += (i + 1 < rows && j + 1 < cols && grid[i + 1][j + 1].type == ECell.Mine) ? 1 : 0;
						grid[i][j].type = ECell.number(surroundingMines);
					}
				}
			}
		}
		
		private function scatterMines(grid:Vector.<Vector.<Cell>>, num:int):void {
			var rows:int = grid.length;
			var cols:int = grid[0].length;
			
			if (rows * cols < num) {
				throw new Error("grid is too small");
			}
			
			var placed:int = 0;
			var row:int, col:int;
			while (placed < num) {
				row = Math.floor(Math.random() * rows);
				col = Math.floor(Math.random() * cols);
				
				if (grid[row][col].type != ECell.Mine) {
					grid[row][col].type = ECell.Mine;
					placed++;
				}
			}
		}
		
		private function createZeroMatrix(x:int, y:int):Vector.<Vector.<Cell>> {
			var matrix:Vector.<Vector.<Cell>> = new Vector.<Vector.<Cell>>();
			var i:int, j:int;
			
			for (i = 0; i < x; i++) {
				matrix.push(createZeroVector(y));
			}
			
			return matrix;
		}
		
		private function createZeroVector(x:int):Vector.<Cell> {
			var vector:Vector.<Cell> = new Vector.<Cell>();
			var i:int;
			for (i = 0; i < x; i++) {
				vector.push(new Cell());
			}
			
			return vector;
		}
	
	}

}