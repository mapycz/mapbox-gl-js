// @flow

import StyleLayer from '../style_layer';

import type {LayerSpecification} from '../../style-spec/types';

class ElevationStyleLayer extends StyleLayer {

    constructor(layer: LayerSpecification) {
        super(layer, {});
    }

    hasOffscreenPass() {
        return true;
    }
}

export default ElevationStyleLayer;
