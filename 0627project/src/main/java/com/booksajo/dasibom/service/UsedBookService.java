package com.booksajo.dasibom.service;

import java.util.ArrayList;
import java.util.List;

import com.booksajo.dasibom.vo.UsedBookVO;



public interface UsedBookService {
	UsedBookVO getUsedBook(int post_Id);
	List<UsedBookVO> getAllUsedBooks();
    ArrayList<UsedBookVO> getUsedBooksByPage(int startRow, int endRow); // ?éò?ù¥Ïß?
    int getUsedBookCount(); // Ï¥? Í≤åÏãúÎ¨? ?àò
    int insertUsedBook(UsedBookVO vo);  // ?ì±Î°?
    int updateUsedBook(UsedBookVO vo);  // ?àò?†ï
    int deleteUsedBook(int post_Id);     // ?Ç≠?†ú
}
