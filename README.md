Share
======

Save, text, email, tweet, or post an image with a single class.

How to use
----------

Extensive sample project is included in ShareDemo folder, but here's the gist:

```swift
// Save an image
Share.defaultInstance.sendImageToSource(.CameraRoll, image: image, presentingViewController: self) { error in
    print("\(error)")
}

// Text an image
Share.defaultInstance.sendImageToSource(.Text, image: image, presentingViewController: self) { error in
    print("\(error)")
}

// Email an image
Share.defaultInstance.sendImageToSource(.Email, image: image, presentingViewController: self) { error in
    print("\(error)")
}

// To Tweet an image
Share.defaultInstance.sendImageToSource(.Tweet, image: image, presentingViewController: self) { error in
    print("\(error)")
}

// To Post an image
Share.defaultInstance.sendImageToSource(.Facebook, image: image, presentingViewController: self) { error in
    print("\(error)")
}
```

