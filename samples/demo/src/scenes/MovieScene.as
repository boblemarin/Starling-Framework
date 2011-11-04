package scenes
{
    import flash.media.Sound;
    
    import starling.core.Starling;
    import starling.display.StMovieClip;
    import starling.events.StEvent;
    import starling.text.StTextField;
    import starling.textures.Texture;
    import starling.utils.HAlign;
    import starling.utils.VAlign;

    public class MovieScene extends Scene
    {
        private var mMovie:StMovieClip;
        
        public function MovieScene()
        {
            var description:String = "Animation provided by angryanimator.com";
            var infoText:StTextField = new StTextField(300, 30, description);
            infoText.x = infoText.y = 10;
            infoText.vAlign = VAlign.TOP;
            infoText.hAlign = HAlign.CENTER;
            addChild(infoText);
            
            var frames:Vector.<Texture> = Assets.getTextureAtlas().getTextures("walk_");
            mMovie = new StMovieClip(frames, 12);
            
            // add sounds
            var stepSound:Sound = Assets.getSound("Step");
            mMovie.setFrameSound(1, stepSound);
            mMovie.setFrameSound(7, stepSound);
            
            // move the clip to the center and add it to the stage
            mMovie.x = Constants.CenterX - int(mMovie.width / 2);
            mMovie.y = Constants.CenterY - int(mMovie.height / 2);
            addChild(mMovie);
            
            // like any animation, the movie needs to be added to the juggler!
            // this is the recommended way to do that.
            addEventListener(StEvent.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(StEvent.REMOVED_FROM_STAGE, onRemovedFromStage);
        }
        
        private function onAddedToStage(event:StEvent):void
        {
            Starling.juggler.add(mMovie);
        }
        
        private function onRemovedFromStage(event:StEvent):void
        {
            Starling.juggler.remove(mMovie);
        }
        
        public override function dispose():void
        {
            removeEventListener(StEvent.REMOVED_FROM_STAGE, onRemovedFromStage);
            removeEventListener(StEvent.ADDED_TO_STAGE, onAddedToStage);
            super.dispose();
        }
    }
}