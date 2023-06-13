import 'package:chess/chess.dart';

class GameTreeNode {
  final Chess chess;
  final Move? move;
  final List<GameTreeNode> children;

  GameTreeNode(this.chess, {this.move, required this.children});
}

class ChessGameTree {
  late GameTreeNode root;
  late GameTreeNode currentNode;

  ChessGameTree(Chess initialPosition) {
    root = GameTreeNode(initialPosition.copy(), children: []);
    currentNode = root;
  }

  void addMove(Move move) {
    Chess currentChess = currentNode.chess.copy();

    GameTreeNode newNode = GameTreeNode(currentChess, move: move, children: []);
    currentNode.children.add(newNode);
    currentNode = newNode;
  }

  void removeMove() {
    GameTreeNode? previousNode = _findParentNode(root, currentNode);
    for (var i = 0; i < previousNode!.children.length; i++) {
      if (previousNode.children[i] == currentNode) {
        previousNode.children.remove(i);
        currentNode = previousNode;
      }
    }
  }

  void reset() {
    root = GameTreeNode(Chess(), children: []);
    currentNode = root;
  }

  void navigateToParent() {
    if (currentNode.children.isNotEmpty) {
      currentNode = _findParentNode(root, currentNode)!;
    }
  }

  GameTreeNode? _findParentNode(GameTreeNode node, GameTreeNode childNode) {
    for (var child in node.children) {
      if (child == childNode) {
        return node;
      } else {
        var parent = _findParentNode(child, childNode);
        if (parent != null) {
          return parent;
        }
      }
    }
    return null;
  }

  void navigateToChild(int index) {
    if (index >= 0 && index < currentNode.children.length) {
      currentNode = currentNode.children[index];
    }
  }

  List<Move> getDownstreamMoves(GameTreeNode node) {
    List<Move> moves = [];

    void traverseTree(GameTreeNode node) {
      if (node.move != null) {
        moves.add(node.move!);
      }

      for (var child in node.children) {
        traverseTree(child);
      }
    }

    traverseTree(node);

    return moves;
  }

  List<String> getDownstreamMovesAlgebraic(GameTreeNode node) {
    List<String> moves = [];

    void traverseTree(GameTreeNode node) {
      if (node.move != null) {
        moves.add(node.move!.toAlgebraic);
      }

      for (var child in node.children) {
        traverseTree(child);
      }
    }

    traverseTree(node);

    return moves;
  }
}
