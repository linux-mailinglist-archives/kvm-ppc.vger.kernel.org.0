Return-Path: <kvm-ppc+bounces-59-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DE7886696C
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Feb 2024 05:39:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 959A6280EB1
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Feb 2024 04:39:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A773B18E02;
	Mon, 26 Feb 2024 04:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pygUoHUX"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D908F125DB
	for <kvm-ppc@vger.kernel.org>; Mon, 26 Feb 2024 04:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708922392; cv=none; b=YDv3rpo3vzUDw2fDU4lyrhOPK8+yEUmefk5eMTXEjNoAxzZNkaO8jZzHR02gAcI3zYEhQWOGvyB4f684SEyRB5qGoqG+vVxE1sDA1iqSqFRulYe/DJS8XmXJ2+W3tGrOTSUCjb7dQLTpa5EI5M6PSxCoAWt4FAQLcFpmSMZ6Qxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708922392; c=relaxed/simple;
	bh=ehOUj2kPgHRPu6xcrsPrcnO32KGtAbHjKt4vz39Cr4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tBfDBKXBt6tnuEjIG7KfYZBsiUgQzDkQdpp88X4JDqMXbDbfVQKAT+gpTpiufZawFWPbHtsTD8sES6LJ/xsfI2tqbU7bcr76MXffySXqbHN02OwPnE9Ye3gFQEvmM3exyarAY9/H6PxCxER7qrFFNbKDm3D1thLfOi45o/lyyIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com; spf=none smtp.mailfrom=linux.vnet.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pygUoHUX; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.vnet.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41Q2GHoo015583;
	Mon, 26 Feb 2024 04:39:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=IaFvBKfMO4TTEcbs/FcaKuZt4upZWYYOQik7kMFOe3I=;
 b=pygUoHUXWE8kElq3fnMP5nSv1wis9BcwgnybTXynDlY+eZlbGHsTF462tdMEBAaopiFm
 2JVMH1LsRk2llCfluE+Pb529hyaDgETZ4gdrxby/m++lyzYkjm8Sj6/9PhbR8ZXOm36f
 LMaEAPclakrTslFKVTjKNmISUfHG1zweGTJ6ASTJkRGXyxoeLJjpEHCT9DP04DSEv80n
 qaH1vZDtf1XOCaCoVQWT9tG+y4Eduhmmw6N13f8wHhsmYKU7DIboqFBayOoS1mb6MaH4
 DACIemOafeDivhsOnWu1OPR9jGj+kkQwJ/oDZ5BWyjsR0QDRe84lzb02nlFkVVUuCrqn Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wg2hc574j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Feb 2024 04:39:36 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41Q3xvAD027112;
	Mon, 26 Feb 2024 04:39:36 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wg2hc574b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Feb 2024 04:39:35 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 41Q3sFPk008852;
	Mon, 26 Feb 2024 04:39:35 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3wftst71uf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Feb 2024 04:39:34 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 41Q4dV0X17891974
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 04:39:33 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 40E8620043;
	Mon, 26 Feb 2024 04:39:31 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E25BF20040;
	Mon, 26 Feb 2024 04:39:29 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.109.216.99])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 26 Feb 2024 04:39:29 +0000 (GMT)
Date: Mon, 26 Feb 2024 10:09:27 +0530
From: Kautuk Consul <kconsul@linux.vnet.ibm.com>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Thomas Huth <thuth@redhat.com>, aik@ozlabs.ru, groug@kaod.org,
        slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH v2] slof/engine.in: refine +COMP and -COMP by not using
 COMPILE
Message-ID: <ZdwV/1bmGSGi8MnZ@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240202051548.877087-1-kconsul@linux.vnet.ibm.com>
 <Zcnkzks7D0eHVYZQ@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <20240223205723.GO19790@gate.crashing.org>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223205723.GO19790@gate.crashing.org>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DbhT0aGD7ppsE96-0B0uEJz2v1uuMq3M
X-Proofpoint-GUID: oq0lQLHXN9--bwAmSbuRsMlAXPmupGGB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-26_01,2024-02-23_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 phishscore=0 spamscore=0 clxscore=1015 impostorscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 mlxlogscore=463 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402260033

Hi,

On 2024-02-23 14:57:23, Segher Boessenkool wrote:
> 
> I think both changes are bad.  They reduce abstraction, for no reason at
> all.
> 
> If you think the compiler should inline more, or do better optimisations
> even, work on *that*, don't do one unimportant case of it manually.
> 
> I never made the indirect threading engine in Paflof faster, because it
> was plenty fast already.  In SLOF, almost everything is compiled at
> runtime, and if it is important to speed that up there are some well-
> known usual caching tricks to make things *factors* faster.  The main
> focus points for SLOF were to have an engine that is easily adapted for
> different purposes (and it was! Ask me about it :-) ), and to have
> things using it as debuggable as possible (you really need some hardware
> debugging thing to make it real easy; I had one back then.  You need to
> be able to look at all memory state after a stop (a crash, perhaps), and
> seeing all CPU registers is useful as well.
> 
> If you want to improve engine.in, get rid of it completely?  Make the
> whol thing cross-compile perhaps.  Everything from source code.  The
> engine.in thing is essentially an already compiled thing (but not
> relocated yet, not fixed to some address), which is still in mostly
> obvious 1-1 correspondence to it source code, which can be easily
> "uncompiled" as well.  Like:

:-). Getting rid of it completely and making the whole thing
cross-compile would require more time that I'm not so sure that I or
even my manager would be able to spare in our project.

> 
> col(+COMP STATE @ 1 STATE +! 0BRANCH(1) EXIT HERE THERE ! COMP-BUFFER DOTO HERE COMPILE DOCOL)
> col(-COMP -1 STATE +! STATE @ 0BRANCH(1) EXIT COMPILE EXIT THERE @ DOTO HERE COMP-BUFFER EXECUTE)
> 
> : +comp  ( -- )
>   state @  1 state +!  IF exit THEN
>   here there !
>   comp-buffer to here
>   compile docol ;
> : -comp ( -- )
>   -1 state +!
>   state @ IF exit THEN
>   compile exit
>   there @ to here
>   comp-buffer execute ;
> 
> "['] semicolon compile," is not something a user would ever write.  A
> user would write "compile exit".  It is standard Forth, it works
> anywhere.  It is much more idiomatic..

Okay, I can accept the fact that maybe we should use EXIT instead of
SEMICOLON. But at least can we remove the invocation of the "COMPILE"
keyword in +COMP and -COMP ? The rest of the compiler in slof/engine.in
uses the standard "DOTICK <word> COMPILE," format so why cannot we use
this for -COMP as well as +COMP ?


> 
> 
> Segher

