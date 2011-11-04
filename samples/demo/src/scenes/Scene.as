package scenes
{
    import starling.display.StButton;
    import starling.display.StSprite;
    import starling.events.StEvent;
    
    public class Scene extends StSprite
    {
        public static const CLOSING:String = "closing";
        
        private var mBackButton:StButton;
        
        public function Scene()
        {
            mBackButton = new StButton(Assets.getTexture("ButtonBack"), "Back");
            mBackButton.x = Constants.CenterX - mBackButton.width / 2;
            mBackButton.y = Constants.GameHeight - mBackButton.height + 1;
            mBackButton.addEventListener(StEvent.TRIGGERED, onBackButtonTriggered);
            addChild(mBackButton);
        }
        
        private function onBackButtonTriggered(event:StEvent):void
        {
            mBackButton.removeEventListener(StEvent.TRIGGERED, onBackButtonTriggered);
            dispatchEvent(new StEvent(CLOSING, true));
        }
    }
}