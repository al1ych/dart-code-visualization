// @dart=2.9

part of '../main.dart';

AstNode _getRootDeclaration(AstNode node) {
  while (jumpToDeclaration[node] != null &&
      jumpToDeclaration[node].offset != node.offset) {
    node = jumpToDeclaration[node];
  }
  return node;
}

String _replace(String code, AstNode node, String s) {
  AstNode dRoot = _getRootDeclaration(node);
  List<SimpleIdentifier> usages = jumpToUsages[dRoot];
  // usages.sort((a, b) => a.offset - b.offset); // todo нужно ли сортить?
  String newCode = code.substring(0, usages[0].offset) + s;
  for (int i = 1; i < usages.length; i++) {
    var u0 = usages[i - 1];
    var u1 = usages[i];
    newCode += code.substring(u0.offset + u0.length, u1.offset) + s;
  }
  newCode += code.substring(usages.last.offset + usages.last.length);
  return newCode;
}

String wrapWithTag(String codeString, AstNode node, String tag) {
  return _replace(codeString, node, tag + node.toString() + tag);
}

/*
a:DeclaredSimpleIdentifier:11   -> int a:SimpleFormalParameterImpl:7
x:DeclaredSimpleIdentifier:22   -> x = 5:VariableDeclarationImpl:22
a:SimpleIdentifierImpl:44       -> int a:SimpleFormalParameterImpl:7
x:SimpleIdentifierImpl:48       -> x = 5:VariableDeclarationImpl:22
y:DeclaredSimpleIdentifier:106  -> y = 1:VariableDeclarationImpl:106
y:DeclaredSimpleIdentifier:163  -> y:VariableDeclarationImpl:163
y:SimpleIdentifierImpl:185      -> y:VariableDeclarationImpl:163
y:SimpleIdentifierImpl:243      -> y = 1:VariableDeclarationImpl:106
b:DeclaredSimpleIdentifier:285  -> b = 10:VariableDeclarationImpl:285
b:SimpleIdentifierImpl:309      -> b = 10:VariableDeclarationImpl:285
 */

/*
for node a:11 - declaration root: int a:7
for node x:22 - declaration root: x:22
for node a:44 - declaration root: int a:7
for node x:48 - declaration root: x = 5:22
for node y:106 - declaration root: y:106
for node y:163 - declaration root: y:163
for node y:185 - declaration root: y:163
for node y:243 - declaration root: y = 1:106
for node b:285 - declaration root: b:285
for node b:309 - declaration root: b = 10:285
 */
