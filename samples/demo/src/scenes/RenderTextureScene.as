package scenes
{
    import flash.geom.Point;
    
    import starling.display.StImage;
    import starling.events.Touch;
    import starling.events.StTouchEvent;
    import starling.events.TouchPhase;
    import starling.text.StTextField;
    import starling.textures.RenderTexture;
    import starling.utils.HAlign;
    import starling.utils.VAlign;

    public class RenderTextureScene extends Scene
    {
        private var mRenderTexture:RenderTexture;
        private var mBrush:StImage;
        
        public function RenderTextureScene()
        {
            var description:String = "Touch the screen to draw eggs!";
            
            var infoText:StTextField = new StTextField(300, 50, description);
            infoText.x = infoText.y = 10;
            infoText.vAlign = VAlign.TOP;
            infoText.hAlign = HAlign.CENTER;
            addChild(infoText);
            
            mBrush = new StImage(Assets.getTexture("EggOpened"));
            mBrush.pivotX = mBrush.width / 2;
            mBrush.pivotY = mBrush.height / 2;
            mBrush.scaleX = mBrush.scaleY = 0.5;
            
            mRenderTexture = new RenderTexture(320, 435); 
            
            var canvas:StImage = new StImage(mRenderTexture);
            canvas.addEventListener(StTouchEvent.TOUCH, onTouch);
            addChild(canvas);
        }
        
        private function onTouch(event:StTouchEvent):void
        {
            var touches:Vector.<Touch> = event.getTouches(this);
            
            for each (var touch:Touch in touches)
            {
                if (touch.phase == TouchPhase.HOVER || touch.phase == TouchPhase.ENDED)
                    continue;
                
                var location:Point = touch.getLocation(this);
                mBrush.x = location.x;
                mBrush.y = location.y;
                
                mRenderTexture.draw(mBrush);
            }
        }
        
        public override function dispose():void
        {
            mRenderTexture.dispose();
            super.dispose();
        }
    }
}