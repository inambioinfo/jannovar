package jannovar.interval;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import jannovar.interval.LeftComparator;

/**
 * Implements the Node structure of the interval tree. The class is inteded to
 * store {@link jannovar.interval.Interval Interval} objects. Each node stores
 * all Intervals that intersect with the {@link #median}. The {@link #leftNode}
 * stores all Intervals that are completely to the left of {@link #median}, and
 * the {@link #rightNode} stores all intervals that are completely to the right.
 * Additionally there are two lists that store orders lists of the Intevals that
 * are stored within the present node. {@link #leftorder} stores the intervals
 * sorted by increased left end points (lowpoint), and {@link #rightorder}
 * stores the same intervals sorted by their right end points (highpoint).
 *
 * @see jannovar.interval.IntervalTree
 * @author Christopher Dommaschenz, Radostina Misirkova, Nadine Taube, Gizem Top
 * @version 0.1 (14 May, 2013)
 */
public class Node<T> {
	/** Median of all intervals in this node */
	public Integer median;
	/** node containing the intervals completely to the left of the median. */ 
	public Node<T> leftNode;
	/** node containing the intervals completely to the right of the median. */
	public Node<T> rightNode;
	/** list of all intervals that cross median of this node. */
	public List<Interval<T>> intervals;
	/**  list of intervals sorted by increasing left end points */
	public List<Interval<T>> leftorder;
	/** list sorted by decreasing right end points */
	public List<Interval<T>> rightorder;
	/** A Comparator that is used to sort intervals by their left endpoint
	 * in ascending order. */
	public static LeftComparator leftcomp = null;
	/** A Comparator that is used to sort intervals by their right endpoint
	 * in descending order. */
	public static RightComparator rightcomp = null;

	/**
	 * Default constructor to create an empty node.
	 */
	public Node() {
		median = 0;
		leftNode = null;
		rightNode = null;
		intervals = new ArrayList<Interval<T>>();
		leftorder = new ArrayList<Interval<T>>();
		rightorder = new ArrayList<Interval<T>>();
	}

	/**
	 * Node constructor.
	 * 
	 * @param intervals A list containing all intervals
	 */
	public Node(List<Interval<T>> intervals) {
		/* helper list to find the median of all interval endpoints */
		List<Integer> endpointslist = new ArrayList<Integer>();
		/* inserts intervals in endpointslist and sorts them */
		for (Interval<T> interval : intervals) {
			endpointslist.add(interval.getLow());
			endpointslist.add(interval.getHigh());
			Collections.sort(endpointslist);
		}
		/* calculates the median of the current node */
		median = findMedian(endpointslist);

		/* lefts stores intervals to the left of the median */
		List<Interval<T>> lefts = new ArrayList<Interval<T>>();
		/* rights stores intervals to the right of the median */
		List<Interval<T>> rights = new ArrayList<Interval<T>>();

		for (Interval<T> interval : intervals) {
			/*
			 * if the highpoint is smaller than the median, insert interval into
			 * lefts
			 */
			if (interval.getHigh() < median) {
				lefts.add(interval);
			/*
			 * if the lowpoint is bigger than the median, insert interval
			 * into rights
			 */
			} else if (interval.getLow() > median) {
				rights.add(interval);
			}
			/** ?????????????????????
			 * Warum nicht hier  else {
				medianIntervals.add(interval);
			 }
			 Das w�re auf jeden Fall effizienter als addAll...remove...remove
			 */
		}
		/* medianIntervals stores all intervals containing the median point */
		List<Interval<T>> medianIntervals = new ArrayList<Interval<T>>();
		/* inserts intervals into medianIntervals */
		medianIntervals.addAll(intervals);
		/* removes lefts from medianIntervals */
		medianIntervals.removeAll(lefts);
		/* removes rights from medianIntervals */
		medianIntervals.removeAll(rights);

		leftorder = new ArrayList<Interval<T>>();
		rightorder = new ArrayList<Interval<T>>();

		/*
		 * Node.leftcomp is a comparator used to sort the low points in increasing order
		 */
		
		Collections.sort(medianIntervals, Node.leftcomp);
		/* leftorder stores sorted medianIntervals */
		leftorder.addAll(medianIntervals);
		/*
		 * Node.rightcomp is a comparator used to sort the high points in decreasing
		 * order
		 */
		Collections.sort(medianIntervals, Node.rightcomp);
		/* rightorder stores sorted medianIntervals */
		rightorder.addAll(medianIntervals);
		/* if lefts is not empty it is stored in leftNode */
		if (lefts.size() > 0) {
			leftNode = new Node<T>(lefts);

		}
		/* if rights is not empty it is stored in rightNode */
		if (rights.size() > 0) {
			rightNode = new Node<T>(rights);
		}
	}

	/**
	 * A static method intended to be used by the IntervalTree
	 * constructor to set the left-comparator once for all
	 * node objects.
	 */
	public static void setLeftComparator(LeftComparator lcmp) { // 
		Node.leftcomp = lcmp;
	}

	/**
	 * A static method intended to be used by the IntervalTree
	 * constructor to set the right-comparator once for all
	 * node objects.
	 */
	public static void setRightComparator(RightComparator rcmp) { // 
		Node.rightcomp = rcmp;
	}



	/**
	 * Calculates the median value of the sorted list. For this purpose, the
	 * method finds the center of the list by dividing the size of the list by
	 * two and stores it in mid. If the size of the list is devisible by two,
	 * the previous element of mid is added to the median and divided by two.
	 * 
	 * @param list A list of integers
	 * @return The median of the list
	 */
	public Integer findMedian(List<Integer> list) {
		/* mid is defined as the center of the list */
		int mid = list.size() / 2;
		/* median is set to mid */
		median = list.get(mid);
		if (list.size() % 2 == 0) {
			median = (median + list.get(mid - 1)) / 2;
		}
		return median;
	}




	




	/**
	 * Checks if a given node is empty.
	 * 
	 * @param node A node of the interval tree
	 * @return True, if the node is empty, otherwise False
	 */
	public boolean isEmpty(Node<T> node) {
		if (node == null)
			return true;
		else {
			return false;
		}
	}

	/**
	 * @return A left node of the interval tree
	 */
	public Node<T> getLeft() {
		return leftNode;
	}

	/**
	 * @return A right node of the interval tree
	 */
	public Node<T> getRight() {
		return rightNode;
	}

}