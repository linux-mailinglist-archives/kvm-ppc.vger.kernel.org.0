Return-Path: <kvm-ppc+bounces-84-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAB7588FDA9
	for <lists+kvm-ppc@lfdr.de>; Thu, 28 Mar 2024 12:02:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 172C81C25F19
	for <lists+kvm-ppc@lfdr.de>; Thu, 28 Mar 2024 11:02:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7B47657B7;
	Thu, 28 Mar 2024 11:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cC3HGYFM"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83BD54BCB
	for <kvm-ppc@vger.kernel.org>; Thu, 28 Mar 2024 11:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711623762; cv=none; b=kfk2qcYdHpz8j73B/lJDKKWJ+uwTarFM1SfCXt8tZqvdynI0Tn8EI00s6zmBwg0eFZ+U7eaQRkuXah6kT5/SXiPApHXwPFjdu3qUkrCpYaj5vP7CP28yM48AJ9aihHL1mV3bsyQzE5+2um3GHr6UyF8TDMO61CebyhxmGKpAf3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711623762; c=relaxed/simple;
	bh=54odSCIHgh606QQ8fiodwmUYP3jPYanr1ZBlCGquXKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=reFDcymfGpTulsg+3VXEzPqL4LzFEpKljuTHAp8DjPrM7pEokge+D3hELSGqpNFhMt+U3ABXZQ1X8oDvQMnL7rOghTDjNGMpZtLphMYkpjI55/fYcOBhSJV9aBUbmi2vYnyzVcp+BOntckx5a2CEyPYbQlDKdoFKUMSn2DCZnJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cC3HGYFM; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42SAwlss024617;
	Thu, 28 Mar 2024 11:02:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=GBpVvDR4sTVJayInjQOckrKzugiXfMmVtWTZTyNIN4U=;
 b=cC3HGYFMwNJHiqQy8RjJCmSm0gApyv0vs0NBCABbbEYBjcBxYmhjAuLFAEU/lWJbEu+U
 Yeb/CQ79hLyisS3NdiPb09FnMyFcQcjaInw9EsX5pLW7RhUp28MdIMSHvu/tTDrImnWm
 1e718YUT/fTJJbgKzkH9IMmRmAgLA9ZWF9sK9xow7P/Vcrjq8r6jFhS4IoBld8h8VLFl
 /Xyvift1KQ0HE4egvhaJQ0i4g/SGFJEwa7RdEvZrZYY7aXkSKqEx17rCcxsQ/1HezErv
 4SDtQipy7YxP/lh9zNC0wfE1Wr7EEjsdVlMxs44O6fl7FClAQQKVJmYv3NeBb1DueTrp nw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x579200dm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 Mar 2024 11:02:31 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42SB2V9J032012;
	Thu, 28 Mar 2024 11:02:31 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x579200dg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 Mar 2024 11:02:31 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42SA5H58003747;
	Thu, 28 Mar 2024 11:02:30 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3x2c434gv0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 Mar 2024 11:02:30 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 42SB2R2A28508802
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Mar 2024 11:02:29 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 67D662004F;
	Thu, 28 Mar 2024 11:02:24 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3AAEF2004B;
	Thu, 28 Mar 2024 11:02:23 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.109.216.99])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 28 Mar 2024 11:02:23 +0000 (GMT)
Date: Thu, 28 Mar 2024 16:32:20 +0530
From: Kautuk Consul <kconsul@linux.ibm.com>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: aik@ozlabs.ru, Thomas Huth <thuth@redhat.com>, slof@lists.ozlabs.org,
        kvm-ppc@vger.kernel.org
Subject: Re: [SLOF] [PATCH v3] slof/fs/packages/disk-label.fs: improve
 checking for DOS boot partitions
Message-ID: <ZgVOPOSekcbrBGCh@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240327054127.633598-1-kconsul@linux.ibm.com>
 <20240327134325.GF19790@gate.crashing.org>
 <ZgT0eCsT8SEiHV2Y@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <20240328104725.GJ19790@gate.crashing.org>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328104725.GJ19790@gate.crashing.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ar8LDwPuZ8bWL6UHe2tH3eSpRxYNcFLN
X-Proofpoint-ORIG-GUID: QnwiNfEik0eIdOjr6GJGXfvuHhDQzFRY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-28_10,2024-03-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 phishscore=0 impostorscore=0 bulkscore=0 adultscore=0
 spamscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403280073

Hi,

On 2024-03-28 05:47:25, Segher Boessenkool wrote:
> On Thu, Mar 28, 2024 at 10:09:20AM +0530, Kautuk Consul wrote:
> > On 2024-03-27 08:43:25, Segher Boessenkool wrote:
> > > If an exception happens you can (should!) throw an exception.  Which
> > > you can then catch at a pretty high level.
> > Ah, correct. Thanks for the suggestion! I think I will now try to throw
> > an exception from read-sector if all the code-paths imply that a "catch"
> > is in progress.
> 
> Don't try to detect something is trying to catch things.  Just throw!
> Always *something* will catch things (the outer interpreter, if nothing
> else), anyway.  In SLOF this is very explicit:
> 
> : quit
>   BEGIN
>     0 rdepth!    \ clear nesting stack
>     [            \ switch to interpretation state
>     terminal     \ all input and output not redirected
>     BEGIN
>       depth . [char] > emit space  \ output prompt
>       refill WHILE
>       space
>       ['] interpret catch          \ that is all the default throw/catch
>                                    \ there is!  no special casing needed
>       dup print-status             \ "ok" or "aborted" or abort" string
>     REPEAT
>   AGAIN ;
> 
> The whole programming model is that you can blindly throw a fatal error
> whenever one happens.  You cannot deal with it anyway, it is fatal!
> That is 98% or so of the exceptions you'll ever see.  Very sometimes it
> is used for non-local control flow.  That has its place, but please
> don't overuse that :-)

Okay, in the v4 I just sent I added a catch statement in the open method
of disk-label.fs to make sure that there is a catch for this throw. Can
you please check that and tell me if I need to remove that CATCH
statement ? My idea was that maybe I needed to add an appropriate CATCH
statement for this in open.
> 
> 
> Segher

