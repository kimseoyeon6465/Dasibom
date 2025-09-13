package com.booksajo.dasibom.service;

import java.util.ArrayList;

import com.booksajo.dasibom.vo.PostsVO;



public interface PostService {

	int getPostCount();

	ArrayList<PostsVO> getNoticePosts(); // ������ ��ȸ

	ArrayList<PostsVO> getAllContentsWithoutNotice(int startRow, int endRow); // ���� ���� �Ϲ� �� ��ȸ

	ArrayList<PostsVO> getAllContents(int startRow, int endRow);

	ArrayList<PostsVO> getAllComments();

	PostsVO getContent(Integer post_id);

	boolean insertPost(String category, String title, String content, String user_id, String image_path);

	boolean updatePost(int post_id, String category, String title, String content, String user_id, String image_path);

	boolean deletePost(int post_id);

	int getCommentCountForPost(Integer post_id);

	ArrayList<PostsVO> searchPostsByKeyword(String keyword);

	int getSearchPostCount(String keyword);

	ArrayList<PostsVO> searchPostsByKeywordPaged(String keyword, int startIndex, int pageSize);

	int getPostCountWithoutNotice();

	int getPostCountByCategory(String string);

	ArrayList<PostsVO> getPostsByCategoryPaged(String string, int startRow, int postsPerPage);

}