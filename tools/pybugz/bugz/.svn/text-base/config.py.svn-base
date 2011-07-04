#!/usr/bin/env python

from bugz import __version__
import csv
import locale

BUGZ_USER_AGENT = 'PyBugz/%s +http://www.github.com/ColdWind/pybugz/' % __version__

class BugzConfig:
	urls = {
		'auth': 'index.cgi',
		'list': 'buglist.cgi',
		'show': 'show_bug.cgi',
		'attach': 'attachment.cgi',
		'post': 'post_bug.cgi',
		'modify': 'process_bug.cgi',
		'attach_post': 'attachment.cgi',
	}

	headers = {
		'Accept': '*/*',
		'User-agent': BUGZ_USER_AGENT,
	}

	params = {
		'auth': {
		"Bugzilla_login": "",
		"Bugzilla_password": "",
		"GoAheadAndLogIn": "1",
		},

		'post': {
		'product': '',
		'version': '0.0',
		'rep_platform': 'All',
		'op_sys': 'Linux',
		'priority': 'Normal',
		'bug_severity': 'Mineure',
		'bug_status': 'NEW',
		'assigned_to': '',
		'keywords': '',
		'dependson':'',
		'blocked':'',
		'component': 'Sans Objet',
		# needs to be filled in
		'bug_file_loc': '',
		'short_desc': '',
		'comment': '',
		'op_sys': 'Syst%C3%A9matique',
		'rep_platform': 'Software',
		'cf_client':'',
		'cf_reference':'',
		'cf_pays':'FR',
		'cf_sysexp':'Linux',
		'cf_site_orig':'RMM',
		'cf_site_dest':'RMM'
		},

		'attach': {
		'id':''
		},

		'attach_post': {
		'action': 'insert',
		'contenttypemethod': 'manual',
		'bugid': '',
		'description': '',
		'contenttypeentry': 'text/plain',
		'comment': '',
		},

		'show': {
		'id': '',
		'ctype': 'xml'
		},

		'list': {
		'query_format': 'advanced',
		'short_desc_type': 'allwordssubstr',
		'short_desc': '',
		'long_desc_type': 'substring',
		'long_desc' : '',
		'bug_file_loc_type': 'allwordssubstr',
		'bug_file_loc': '',
		'status_whiteboard_type': 'allwordssubstr',
		'status_whiteboard': '',
		'bug_status': ['NEW', 'ASSIGNED', 'REOPENED'],
		'bug_severity': [],
		'priority': [],
		'emaillongdesc1': '1',
		'emailassigned_to1':'1',
		'emailtype1': 'substring',
		'email1': '',
		'emaillongdesc2': '1',
		'emailassigned_to2':'1',
		'emailreporter2':'1',
		'emailcc2':'1',
		'emailtype2':'substring',
		'email2':'',
		'bugidtype':'include',
		'bug_id':'',
		'chfieldfrom':'',
		'chfieldto':'Now',
		'chfieldvalue':'',
		'cmdtype':'doit',
		'order': 'Bug Number',
		'field0-0-0':'noop',
		'type0-0-0':'noop',
		'value0-0-0':'',
		'ctype':'csv',
		},

		'modify': {
		'delta_ts': '',
		'longdesclength': '12',
		'id': '',
		'newcc': '',
		'removecc': '',  # remove selected cc's if set
		'cc': '',        # only if there are already cc's
		'bug_file_loc': '',
		'bug_severity': '',
		'bug_status': '',
		'op_sys': '',
		'priority': '',
		'version': '',
		'target_milestone': '',
		'rep_platform': '',
		'product':'',
		'component': '',
		'short_desc': '',
		'status_whiteboard': '',
		'keywords': '',
		'dependson': '',
		'blocked': '',
		'knob': ('none', 'assigned', 'resolve', 'duplicate', 'reassign'),
		'resolution': '', # only valid for knob=resolve
		'dup_id': '',     # only valid for knob=duplicate
		'assigned_to': '',# only valid for knob=reassign
		'form_name': 'process_bug',
		'comment':'',
		'cf_causes':'---',
		'cf_commentaire_cause':'',
		'cf_solution':'',
		'cf_derogation':'',
		'cf_application':'',
		'cf_ref_action':'',
		'cf_dispositions':'',
		'cf_resultats':'',
		'cf_nouvelles_dispositions':'',
		'cf_ref_externe':'',
		'cf_client':'*',
		'cf_reference':'*',
		'cf_pays':'FR',
		'cf_sysexp':'Linux',
		'cf_site_orig':'RMM',
		'cf_site_dest':'RMM',
		'flag_type-49':'X'
		},

		'namedcmd': {
		'cmdtype' : 'runnamed',
		'namedcmd' : '',
		'ctype':'csv'
		}
	}

	choices = {
		'status': {
		'unconfirmed': 'UNCONFIRMED',
		'new': 'NEW',
		'assigned': 'ASSIGNED',
		'reopened': 'REOPENED',
		'resolved': 'RESOLVED',
		'verified': 'VERIFIED',
		'closed':   'CLOSED'
		},

		'order': {
		'number' : 'Bug Number',
		'assignee': 'Assignee',
		'importance': 'Importance',
		'date': 'Last Changed'
		},

		'columns': [
		'bugid',
		'alias',
		'severity',
		'priority',
		'arch',
		'assignee',
		'status',
		'resolution',
		'desc'
		],

		'column_alias': {
		'bug_id': 'bugid',
		'product': 'product',
		'alias': 'alias',
		'bug_severity': 'severity',
		'priority': 'priority',
		'op_sys': 'arch', #XXX: Gentoo specific?
		'assigned_to': 'assignee',
		'assigned_to_realname': 'assignee', #XXX: Distinguish from assignee?
		'bug_status': 'status',
		'resolution': 'resolution',
		'short_desc': 'desc',
		'short_short_desc': 'desc',
		},
		# Novell: bug_id,"bug_severity","priority","op_sys","bug_status","resolution","short_desc"
		# Gentoo: bug_id,"bug_severity","priority","op_sys","assigned_to","bug_status","resolution","short_short_desc"
		# Redhat: bug_id,"alias","bug_severity","priority","rep_platform","assigned_to","bug_status","resolution","short_short_desc"
		# Mandriva: 'bug_id', 'bug_severity', 'priority', 'assigned_to_realname', 'bug_status', 'resolution', 'keywords', 'short_desc'

		'resolution': {
		'fixed': 'FIXED',
		'invalid': 'INVALID',
		'duplicate': 'DUPLICATE',
		'lated': 'LATER',
		'needinfo': 'NEEDINFO',
		'wontfix': 'WONTFIX',
		'upstream': 'UPSTREAM',
		},

		'severity': [
		'blocker',
		'critical',
		'major',
		'normal',
		'minor',
		'trivial',
		'enhancement',
		'QA',
		'Mineure',
		'Majeur',
		'Evolution',
		'Critique',
		],

		'priority': {
		1:'P1',
		2:'P2',
		3:'P3',
		4:'P4',
		5:'P5',
		6:'Normal',
		7:'Urgent',
		}

	}

	convtab = {
		'utftab' : {
				u'\x80' : '%C2%80', #<CONTROL>
				u'\x81' : '%C2%81', #<CONTROL>
				u'\x82' : '%C2%82', #<CONTROL>
				u'\x83' : '%C2%83', #<CONTROL>
				u'\x84' : '%C2%84', #<CONTROL>
				u'\x85' : '%C2%85', #<CONTROL>
				u'\x86' : '%C2%86', #<CONTROL>
				u'\x87' : '%C2%87', #<CONTROL>
				u'\x88' : '%C2%88', #<CONTROL>
				u'\x89' : '%C2%89', #<CONTROL>
				u'\x8a' : '%C2%8A', #<CONTROL>
				u'\x8b' : '%C2%8B', #<CONTROL>
				u'\x8c' : '%C2%8C', #<CONTROL>
				u'\x8d' : '%C2%8D', #<CONTROL>
				u'\x8e' : '%C2%8E', #<CONTROL>
				u'\x8f' : '%C2%8F', #<CONTROL>
				u'\x90' : '%C2%90', #<CONTROL>
				u'\x91' : '%C2%91', #<CONTROL>
				u'\x92' : '%C2%92', #<CONTROL>
				u'\x93' : '%C2%93', #<CONTROL>
				u'\x94' : '%C2%94', #<CONTROL>
				u'\x95' : '%C2%95', #<CONTROL>
				u'\x96' : '%C2%96', #<CONTROL>
				u'\x97' : '%C2%97', #<CONTROL>
				u'\x98' : '%C2%98', #<CONTROL>
				u'\x99' : '%C2%99', #<CONTROL>
				u'\x9a' : '%C2%9A', #<CONTROL>
				u'\x9b' : '%C2%9B', #<CONTROL>
				u'\x9c' : '%C2%9C', #<CONTROL>
				u'\x9d' : '%C2%9D', #<CONTROL>
				u'\x9e' : '%C2%9E', #<CONTROL>
				u'\x9f' : '%C2%9F', #<CONTROL>
				u'\xa0' : '%C2%A0', #NO-BREAK SPACE
				u'\xa1' : '%C2%A1', #INVERTED EXCLAMATION MARK
				u'\xa2' : '%C2%A2', #CENT SIGN
				u'\xa3' : '%C2%A3', #POUND SIGN
				u'\xa4' : '%C2%A4', #CURRENCY SIGN
				u'\xa5' : '%C2%A5', #YEN SIGN
				u'\xa6' : '%C2%A6', #BROKEN BAR
				u'\xa7' : '%C2%A7', #SECTION SIGN
				u'\xa8' : '%C2%A8', #DIAERESIS
				u'\xa9' : '%C2%A9', #COPYRIGHT SIGN
				u'\xaa' : '%C2%AA', #FEMININE ORDINAL INDICATOR
				u'\xab' : '%C2%AB', #LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
				u'\xac' : '%C2%AC', #NOT SIGN
				u'\xad' : '%C2%AD', #SOFT HYPHEN
				u'\xae' : '%C2%AE', #REGISTERED SIGN
				u'\xaf' : '%C2%AF', #MACRON
				u'\xb0' : '%C2%B0', #DEGREE SIGN
				u'\xb1' : '%C2%B1', #PLUS-MINUS SIGN
				u'\xb2' : '%C2%B2', #SUPERSCRIPT TWO
				u'\xb3' : '%C2%B3', #SUPERSCRIPT THREE
				u'\xb4' : '%C2%B4', #ACUTE ACCENT
				u'\xb5' : '%C2%B5', #MICRO SIGN
				u'\xb6' : '%C2%B6', #PILCROW SIGN
				u'\xb7' : '%C2%B7', #MIDDLE DOT
				u'\xb8' : '%C2%B8', #CEDILLA
				u'\xb9' : '%C2%B9', #SUPERSCRIPT ONE
				u'\xba' : '%C2%BA', #MASCULINE ORDINAL INDICATOR
				u'\xbb' : '%C2%BB', #RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
				u'\xbc' : '%C2%BC', #VULGAR FRACTION ONE QUARTER
				u'\xbd' : '%C2%BD', #VULGAR FRACTION ONE HALF
				u'\xbe' : '%C2%BE', #VULGAR FRACTION THREE QUARTERS
				u'\xbf' : '%C2%BF', #INVERTED QUESTION MARK
				u'\xc0' : '%C3%80', #LATIN CAPITAL LETTER A WITH GRAVE
				u'\xc1' : '%C3%81', #LATIN CAPITAL LETTER A WITH ACUTE
				u'\xc2' : '%C3%82', #LATIN CAPITAL LETTER A WITH CIRCUMFLEX
				u'\xc3' : '%C3%83', #LATIN CAPITAL LETTER A WITH TILDE
				u'\xc4' : '%C3%84', #LATIN CAPITAL LETTER A WITH DIAERESIS
				u'\xc5' : '%C3%85', #LATIN CAPITAL LETTER A WITH RING ABOVE
				u'\xc6' : '%C3%86', #LATIN CAPITAL LETTER AE
				u'\xc7' : '%C3%87', #LATIN CAPITAL LETTER C WITH CEDILLA
				u'\xc8' : '%C3%88', #LATIN CAPITAL LETTER E WITH GRAVE
				u'\xc9' : '%C3%89', #LATIN CAPITAL LETTER E WITH ACUTE
				u'\xca' : '%C3%8A', #LATIN CAPITAL LETTER E WITH CIRCUMFLEX
				u'\xcb' : '%C3%8B', #LATIN CAPITAL LETTER E WITH DIAERESIS
				u'\xcc' : '%C3%8C', #LATIN CAPITAL LETTER I WITH GRAVE
				u'\xcd' : '%C3%8D', #LATIN CAPITAL LETTER I WITH ACUTE
				u'\xce' : '%C3%8E', #LATIN CAPITAL LETTER I WITH CIRCUMFLEX
				u'\xcf' : '%C3%8F', #LATIN CAPITAL LETTER I WITH DIAERESIS
				u'\xd0' : '%C3%90', #LATIN CAPITAL LETTER ETH
				u'\xd1' : '%C3%91', #LATIN CAPITAL LETTER N WITH TILDE
				u'\xd2' : '%C3%92', #LATIN CAPITAL LETTER O WITH GRAVE
				u'\xd3' : '%C3%93', #LATIN CAPITAL LETTER O WITH ACUTE
				u'\xd4' : '%C3%94', #LATIN CAPITAL LETTER O WITH CIRCUMFLEX
				u'\xd5' : '%C3%95', #LATIN CAPITAL LETTER O WITH TILDE
				u'\xd6' : '%C3%96', #LATIN CAPITAL LETTER O WITH DIAERESIS
				u'\xd7' : '%C3%97', #MULTIPLICATION SIGN
				u'\xd8' : '%C3%98', #LATIN CAPITAL LETTER O WITH STROKE
				u'\xd9' : '%C3%99', #LATIN CAPITAL LETTER U WITH GRAVE
				u'\xda' : '%C3%9A', #LATIN CAPITAL LETTER U WITH ACUTE
				u'\xdb' : '%C3%9B', #LATIN CAPITAL LETTER U WITH CIRCUMFLEX
				u'\xdc' : '%C3%9C', #LATIN CAPITAL LETTER U WITH DIAERESIS
				u'\xdd' : '%C3%9D', #LATIN CAPITAL LETTER Y WITH ACUTE
				u'\xde' : '%C3%9E', #LATIN CAPITAL LETTER THORN
				u'\xdf' : '%C3%9F', #LATIN SMALL LETTER SHARP S
				u'\xe0' : '%C3%A0', #LATIN SMALL LETTER A WITH GRAVE
				u'\xe1' : '%C3%A1', #LATIN SMALL LETTER A WITH ACUTE
				u'\xe2' : '%C3%A2', #LATIN SMALL LETTER A WITH CIRCUMFLEX
				u'\xe3' : '%C3%A3', #LATIN SMALL LETTER A WITH TILDE
				u'\xe4' : '%C3%A4', #LATIN SMALL LETTER A WITH DIAERESIS
				u'\xe5' : '%C3%A5', #LATIN SMALL LETTER A WITH RING ABOVE
				u'\xe6' : '%C3%A6', #LATIN SMALL LETTER AE
				u'\xe7' : '%C3%A7', #LATIN SMALL LETTER C WITH CEDILLA
				u'\xe8' : '%C3%A8', #LATIN SMALL LETTER E WITH GRAVE
				u'\xe9' : '%C3%A9', #LATIN SMALL LETTER E WITH ACUTE
				u'\xea' : '%C3%AA', #LATIN SMALL LETTER E WITH CIRCUMFLEX
				u'\xeb' : '%C3%AB', #LATIN SMALL LETTER E WITH DIAERESIS
				u'\xec' : '%C3%AC', #LATIN SMALL LETTER I WITH GRAVE
				u'\xed' : '%C3%AD', #LATIN SMALL LETTER I WITH ACUTE
				u'\xee' : '%C3%AE', #LATIN SMALL LETTER I WITH CIRCUMFLEX
				u'\xef' : '%C3%AF', #LATIN SMALL LETTER I WITH DIAERESIS
				u'\xf0' : '%C3%B0', #LATIN SMALL LETTER ETH
				u'\xf1' : '%C3%B1', #LATIN SMALL LETTER N WITH TILDE
				u'\xf2' : '%C3%B2', #LATIN SMALL LETTER O WITH GRAVE
				u'\xf3' : '%C3%B3', #LATIN SMALL LETTER O WITH ACUTE
				u'\xf4' : '%C3%B4', #LATIN SMALL LETTER O WITH CIRCUMFLEX
				u'\xf5' : '%C3%B5', #LATIN SMALL LETTER O WITH TILDE
				u'\xf6' : '%C3%B6', #LATIN SMALL LETTER O WITH DIAERESIS
				u'\xf7' : '%C3%B7', #DIVISION SIGN
				u'\xf8' : '%C3%B8', #LATIN SMALL LETTER O WITH STROKE
				u'\xf9' : '%C3%B9', #LATIN SMALL LETTER U WITH GRAVE
				u'\xfa' : '%C3%BA', #LATIN SMALL LETTER U WITH ACUTE
				u'\xfb' : '%C3%BB', #LATIN SMALL LETTER U WITH CIRCUMFLEX
				u'\xfc' : '%C3%BC', #LATIN SMALL LETTER U WITH DIAERESIS
				u'\xfd' : '%C3%BD', #LATIN SMALL LETTER Y WITH ACUTE
				u'\xfe' : '%C3%BE', #LATIN SMALL LETTER THORN
				u'\xff' : '%C3%BF', #LATIN SMALL LETTER Y WITH DIAERESIS
		}
	}

#
# Global configuration
#

try:
	config
except NameError:
	config = BugzConfig()

