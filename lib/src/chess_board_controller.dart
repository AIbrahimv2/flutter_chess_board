import 'package:chess/chess.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'game_tree.dart';

class ChessBoardController extends ValueNotifier<Chess> {
  late Chess game;
  late ChessGameTree gameTree;

  factory ChessBoardController() =>
      ChessBoardController._(Chess(), ChessGameTree(Chess().fen));

  factory ChessBoardController.fromGame(Chess game, ChessGameTree gameTree) =>
      ChessBoardController._(game, gameTree);

  factory ChessBoardController.fromFEN(String fen) =>
      ChessBoardController._(Chess.fromFEN(fen), ChessGameTree(fen));

  ChessBoardController._(Chess game, ChessGameTree gameTree)
      : this.game = game,
        this.gameTree = gameTree,
        super(game);

  /// Makes move on the board
  void makeMove({required String from, required String to}) {
    game.move({"from": from, "to": to});
    print(game.history.last.move.piece);
    gameTree.addMove(game.history.last.move, game);
    notifyListeners();
  }

  /// Makes move and promotes pawn to piece (from is a square like d4, to is also a square like e3, pieceToPromoteTo is a String like "Q".
  /// pieceToPromoteTo String will be changed to enum in a future update and this method will be deprecated in the future
  void makeMoveWithPromotion(
      {required String from,
      required String to,
      required String pieceToPromoteTo}) {
    game.move({"from": from, "to": to, "promotion": pieceToPromoteTo});
    gameTree.addMove(game.moves().last, game);
    notifyListeners();
  }

  /// Makes move on the board
  void makeMoveWithNormalNotation(String move) {
    game.move(move);
    gameTree.addMove(game.moves().last, game);
    notifyListeners();
  }

  /// Sets `controller.game` to the game state saved in the GameTree's previous/parent node.
  void goBack() {
    print(gameTree.currentNode.fen);
    gameTree.navigateToParent();
    print(gameTree.currentNode.fen);
    game.load(gameTree.currentNode.fen);
    // game = Chess.fromFEN(gameTree.currentNode.fen);
    notifyListeners();
  }

  void goForward() {
    gameTree.navigateToChild(0);
    game.load(gameTree.currentNode.fen);
    notifyListeners();
  }

  void undoMove() {
    if (game.half_moves == 0) {
      return;
    }
    game.undo_move();
    gameTree.removeMove();
    notifyListeners();
  }

  void resetBoard() {
    game.reset();
    gameTree.reset();
    notifyListeners();
  }

  /// Clears board
  void clearBoard() {
    game.clear();
    notifyListeners();
  }

  /// Puts piece on a square
  void putPiece(BoardPieceType piece, String square, PlayerColor color) {
    game.put(_getPiece(piece, color), square);
    notifyListeners();
  }

  /// Loads a PGN
  void loadPGN(String pgn) {
    game.load_pgn(pgn);
    notifyListeners();
  }

  /// Loads a FEN
  void loadFen(String fen) {
    game.load(fen);
    notifyListeners();
  }

  bool isInCheck() {
    return game.in_check;
  }

  bool isCheckMate() {
    return game.in_checkmate;
  }

  bool isDraw() {
    return game.in_draw;
  }

  bool isStaleMate() {
    return game.in_stalemate;
  }

  bool isThreefoldRepetition() {
    return game.in_threefold_repetition;
  }

  bool isInsufficientMaterial() {
    return game.insufficient_material;
  }

  bool isGameOver() {
    return game.game_over;
  }

  String getAscii() {
    return game.ascii;
  }

  String getFen() {
    return game.fen;
  }

  String getPGN() {
    return game.pgn();
  }

  List<String?> getSan() {
    return game.san_moves();
  }

  List<Piece?> getBoard() {
    return game.board;
  }

  List<Move> getPossibleMoves() {
    return game.moves({'asObjects': true}) as List<Move>;
  }

  int getMoveCount() {
    return game.move_number;
  }

  int getHalfMoveCount() {
    return game.half_moves;
  }

  /// Gets respective piece
  Piece _getPiece(BoardPieceType piece, PlayerColor color) {
    var convertedColor = color == PlayerColor.white ? Color.WHITE : Color.BLACK;

    switch (piece) {
      case BoardPieceType.Bishop:
        return Piece(PieceType.BISHOP, convertedColor);
      case BoardPieceType.Queen:
        return Piece(PieceType.QUEEN, convertedColor);
      case BoardPieceType.King:
        return Piece(PieceType.KING, convertedColor);
      case BoardPieceType.Knight:
        return Piece(PieceType.KNIGHT, convertedColor);
      case BoardPieceType.Pawn:
        return Piece(PieceType.PAWN, convertedColor);
      case BoardPieceType.Rook:
        return Piece(PieceType.ROOK, convertedColor);
    }
  }
}
