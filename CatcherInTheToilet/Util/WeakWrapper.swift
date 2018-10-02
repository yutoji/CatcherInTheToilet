/// generics <Element> should be class type
class WeakWrapper<Element> {

    private weak var _object: AnyObject?

    init(_ object: Element) {
        self._object = object as AnyObject
        assert(self._object != nil, "'object' must be able to cast to AnyObject")
    }
    var object: Element? {
        return _object as? Element
    }
}
