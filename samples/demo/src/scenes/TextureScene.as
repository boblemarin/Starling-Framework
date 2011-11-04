package scenes
{
    import starling.display.StImage;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;

    public class TextureScene extends Scene
    {
        public function TextureScene()
        {
            // load textures from an atlas
            
            var atlas:TextureAtlas = Assets.getTextureAtlas();
            
            var image1:StImage = new StImage(atlas.getTexture("walk_00"));
            image1.x = 30;
            image1.y = 20;
            addChild(image1);
            
            var image2:StImage = new StImage(atlas.getTexture("walk_01"));
            image2.x = 90;
            image2.y = 50;
            addChild(image2);
            
            var image3:StImage = new StImage(atlas.getTexture("walk_03"));
            image3.x = 150;
            image3.y = 80;
            addChild(image3);
            
            var image4:StImage = new StImage(atlas.getTexture("walk_05"));
            image4.x = 210;
            image4.y = 110;
            addChild(image4);
            
            // display a compressed texture
            
            var compressedTexture:Texture = Assets.getTexture("CompressedTexture");
            var image:StImage = new StImage(compressedTexture);
            image.x = Constants.CenterX - image.width / 2;
            image.y = 280;
            addChild(image);
            
        }
    }
}