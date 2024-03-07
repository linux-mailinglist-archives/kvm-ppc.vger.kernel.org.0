Return-Path: <kvm-ppc+bounces-66-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3628874837
	for <lists+kvm-ppc@lfdr.de>; Thu,  7 Mar 2024 07:34:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 93955B213E5
	for <lists+kvm-ppc@lfdr.de>; Thu,  7 Mar 2024 06:34:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B23E8F66;
	Thu,  7 Mar 2024 06:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OTnCigLg"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20933DDC9
	for <kvm-ppc@vger.kernel.org>; Thu,  7 Mar 2024 06:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709793237; cv=none; b=ut5VEWnS3FOKaq22rM6dgg+BC2mvyyYrQqfR8WCxQuo+MRlVRWNFH3cc93u2Zh72aumNH6Q18Na8SZvcwqxNq+rPYNLMV6Dchsy3crS3+NDkHTm57yotoD73uw/iBh8MNl5U9MJU6FgdPcV+laTKX3MeiAQiSiJrLiA8AvgwgWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709793237; c=relaxed/simple;
	bh=01FNooJuIl8lmRzCPll3TEPHpAwa12A5HCUII93UqIM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MmcvoAgAjknmm+AYgrf37+JeprLoBZrVfawHSk7ZNs0C+2p8Z34GEz9R8ljN5MWn2e1MGkYQSPHAy+IA5DxQ8JTnyyetufI5h8jt2EsapE87C2vrBIateOKL1Gbt2QZ0y9LPq9yV8JCblksYchEQxDNXfn7V+ZRUFIbDivema04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com; spf=none smtp.mailfrom=linux.vnet.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OTnCigLg; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.vnet.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4276WZ6n015437;
	Thu, 7 Mar 2024 06:33:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=HdooDH9NeauE+vJH1k/XdDeeg+G3eCTz9mnUF1IDjEo=;
 b=OTnCigLguDpHKLI1GWT061nZldWmBOC2yIPy/PokeBYVQEmRgLz2kdpvk+cpm0foXhML
 zMmL7ahrNoC396XUY8CkBMXgNoLUekSHb7g2hSXxoNTsoeetzN+r5rXoGy4tIHIYzCR6
 4hxsA3AK293979kqX4YGMDONcm4ptkj7k0t9xOxDyz9H4TSFWbZI1nYdy2WLodXlEKvT
 QUmGQ0Lo8wIEjfI1knTdQp3oaQx4LeMbmbnTIpKiM+wL7ErESqrgAVf/9X3nycTGPspC
 58RRlo6qYPd+I1fVEwPC/iwR2+0FwIFNLyW2chhW7Ln0UUOeH8q8rZqwNefews+JBZJO 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wq8d800y0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Mar 2024 06:33:44 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4276XSnn018391;
	Thu, 7 Mar 2024 06:33:44 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wq8d800xe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Mar 2024 06:33:44 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42738U7l024160;
	Thu, 7 Mar 2024 06:33:43 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3wpjwsf38b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Mar 2024 06:33:43 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4276Xdta24642190
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 Mar 2024 06:33:41 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 834762004B;
	Thu,  7 Mar 2024 06:33:39 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3308520040;
	Thu,  7 Mar 2024 06:33:38 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.109.216.99])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  7 Mar 2024 06:33:38 +0000 (GMT)
Date: Thu, 7 Mar 2024 12:03:29 +0530
From: Kautuk Consul <kconsul@linux.vnet.ibm.com>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Thomas Huth <thuth@redhat.com>, aik@ozlabs.ru, groug@kaod.org,
        slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH v2] slof/engine.in: refine +COMP and -COMP by not using
 COMPILE
Message-ID: <ZelfudAMYcXGCgBN@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240202051548.877087-1-kconsul@linux.vnet.ibm.com>
 <Zcnkzks7D0eHVYZQ@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <20240223205723.GO19790@gate.crashing.org>
 <ZdwV/1bmGSGi8MnZ@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZdwV/1bmGSGi8MnZ@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: M3vOnXqUg6WuXUmR8BmAI_NIRp8VbjkJ
X-Proofpoint-GUID: FrhC_84mBfiw_mhyFsQVt1ZZoLa8rRqf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-07_02,2024-03-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=543 lowpriorityscore=0 malwarescore=0 impostorscore=0
 clxscore=1011 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311290000 definitions=main-2403070046

Hi Segher,

> > If you want to improve engine.in, get rid of it completely?  Make the
> > whol thing cross-compile perhaps.  Everything from source code.  The
> > engine.in thing is essentially an already compiled thing (but not
> > relocated yet, not fixed to some address), which is still in mostly
> > obvious 1-1 correspondence to it source code, which can be easily
> > "uncompiled" as well.  Like:
> 
> :-). Getting rid of it completely and making the whole thing
> cross-compile would require more time that I'm not so sure that I or
> even my manager would be able to spare in our project.
> 
> > 
> > col(+COMP STATE @ 1 STATE +! 0BRANCH(1) EXIT HERE THERE ! COMP-BUFFER DOTO HERE COMPILE DOCOL)
> > col(-COMP -1 STATE +! STATE @ 0BRANCH(1) EXIT COMPILE EXIT THERE @ DOTO HERE COMP-BUFFER EXECUTE)
> > 
> > : +comp  ( -- )
> >   state @  1 state +!  IF exit THEN
> >   here there !
> >   comp-buffer to here
> >   compile docol ;
> > : -comp ( -- )
> >   -1 state +!
> >   state @ IF exit THEN
> >   compile exit
> >   there @ to here
> >   comp-buffer execute ;
> > 
> > "['] semicolon compile," is not something a user would ever write.  A
> > user would write "compile exit".  It is standard Forth, it works
> > anywhere.  It is much more idiomatic..
> 
> Okay, I can accept the fact that maybe we should use EXIT instead of
> SEMICOLON. But at least can we remove the invocation of the "COMPILE"
> keyword in +COMP and -COMP ? The rest of the compiler in slof/engine.in
> uses the standard "DOTICK <word> COMPILE," format so why cannot we use
> this for -COMP as well as +COMP ?
> 
Do you agree with the above reasoning as well as the fact that I think
we would all here (in the KVM team) appreciate even this small
improvement in performance ?
Can I send a v3 patch with the "DOTICK EXIT COMPILE," "DOTICK DOCOL COMPILE," changes ?

