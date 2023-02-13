import 'object.dart';
import 'mesh.dart';
import 'scene.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class Button3D extends Object {
  Button3D({
    Vector3? position,
    Vector3? rotation,
    Vector3? scale,
    String? name,
    Mesh? mesh,
    Scene? scene,
    Object? parent,
    List<Object>? children,
    bool backfaceCulling = true,
    bool lighting = false,
    bool visiable = true,
    bool normalized = true,
    String? fileName,
    bool isAsset = true,
  }) : super(
          position: position,
          rotation: rotation,
          scale: scale,
          name: name,
          mesh: mesh,
          scene: scene,
          parent: parent,
          children: children,
          backfaceCulling: backfaceCulling,
          lighting: lighting,
          visiable: visiable,
          normalized: normalized,
          fileName: fileName,
          isAsset: isAsset,
        );

  // 

}