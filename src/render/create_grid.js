// @flow

import { RasterBoundsArray, TriangleIndexArray } from '../data/array_types';
import EXTENT from '../data/extent';

/**
 * Creates uniform grid of triangles, covering EXTENT x EXTENT square, with two
 * adjustent traigles forming a quad, so that there are |count| columns and rows
 * of these quads in EXTENT x EXTENT square.
 * e.g. for count of 2:
 *  -------------
 *  |    /|    /|
 *  |  /  |  /  |
 *  |/    |/    |
 *  -------------
 *  |    /|    /|
 *  |  /  |  /  |
 *  |/    |/    |
 *  -------------
 * @param {number} count Count of rows and columns
 * @private
 */
export default function createGrid(count: Number): [RasterBoundsArray, TriangleIndexArray] {
    const boundsArray = new RasterBoundsArray();
    const indexArray = new TriangleIndexArray();
    boundsArray.reserve(count * count);
    indexArray.reserve((count - 1) * (count - 1) * 2);
    const step = EXTENT / (count - 1);
    const bound = EXTENT + step / 2;
    for (let y = 0; y < bound; y += step) {
        for (let x = 0; x < bound; x += step) {
            boundsArray.emplaceBack(x, y, x, y);
        }
    }
    for (let j = 0; j < count - 1; j++) {
        for (let i = 0; i < count - 1; i++) {
            const index = j * count + i;
            indexArray.emplaceBack(index, index + 1, index + count);
            indexArray.emplaceBack(index + count, index + 1, index + count + 1);
        }
    }
    return [boundsArray, indexArray];
}
