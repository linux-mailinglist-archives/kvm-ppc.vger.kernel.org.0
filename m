Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5073BC611
	for <lists+kvm-ppc@lfdr.de>; Tue,  6 Jul 2021 07:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhGFF3e (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 6 Jul 2021 01:29:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13904 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230008AbhGFF3b (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 6 Jul 2021 01:29:31 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16653vkl030500;
        Tue, 6 Jul 2021 01:26:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : reply-to : references : mime-version : content-type
 : in-reply-to; s=pp1; bh=5F7Fm2R+BhT4NDTOYdxZnSJ9V59bBUcNLsg667NRjv4=;
 b=e64F5UW0nVHs7cXnjSiWHy9yBXbS0bu7p7boL0pCrwv0TUtMCeyzU+Mygm2ASU81rXat
 hM5UIUF4jVRZFKnLrfTdwl/Yb3HRicjQvokR52H9RxW3M4QBM5Jh7iCehjHBfzyP/htk
 kHXmBVE1N/mysFhbd/D5WB555ssf+szzJs+rkhL40cAy/4OLZfhCb5tZZaIYRN1Lrp/q
 iWS2IUADHMu6FPRrdXtZiao4yyYfwyob9EnYalPOjVPYRarMF4DjfTc3fFDDsh5Yww/D
 6mHZHACxkLljzuWgwf7oUVWfRpFV8Nsp7oYZ4ttDV4mX9Zo6WjMHSlJsN8v8iB3wAT1d 9w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mc14nr1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 01:26:41 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 166549GJ031657;
        Tue, 6 Jul 2021 01:26:41 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mc14nr0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 01:26:41 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1665KdNn020248;
        Tue, 6 Jul 2021 05:26:39 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 39jfh8gjqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 05:26:39 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1665QaCB26149282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jul 2021 05:26:36 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47CEDA4040;
        Tue,  6 Jul 2021 05:26:36 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE7C7A404D;
        Tue,  6 Jul 2021 05:26:34 +0000 (GMT)
Received: from in.ibm.com (unknown [9.199.36.69])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  6 Jul 2021 05:26:34 +0000 (GMT)
Date:   Tue, 6 Jul 2021 10:56:32 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        aneesh.kumar@linux.ibm.com, npiggin@gmail.com, paulus@ozlabs.org,
        mpe@ellerman.id.au, farosas@linux.ibm.com
Subject: Re: [PATCH v8 3/6] KVM: PPC: Book3S HV: Add support for
 H_RPT_INVALIDATE
Message-ID: <YOPpiLJlsEBtTmgt@in.ibm.com>
Reply-To: bharata@linux.ibm.com
References: <20210621085003.904767-1-bharata@linux.ibm.com>
 <20210621085003.904767-4-bharata@linux.ibm.com>
 <YOKNub8mS4U4iox0@yekko>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOKNub8mS4U4iox0@yekko>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rJ4eQAChtF-P2Y6mrNwK0C4kLUJo9Y60
X-Proofpoint-GUID: C50eTWCOmWErFezHAgSmEQ04QSa-VHt4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-06_01:2021-07-02,2021-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107060024
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Jul 05, 2021 at 02:42:33PM +1000, David Gibson wrote:
> On Mon, Jun 21, 2021 at 02:20:00PM +0530, Bharata B Rao wrote:
> > diff --git a/arch/powerpc/include/asm/mmu_context.h b/arch/powerpc/include/asm/mmu_context.h
> > index 4bc45d3ed8b0..b44f291fc909 100644
> > --- a/arch/powerpc/include/asm/mmu_context.h
> > +++ b/arch/powerpc/include/asm/mmu_context.h
> > @@ -124,8 +124,17 @@ static inline bool need_extra_context(struct mm_struct *mm, unsigned long ea)
> >  
> >  #if defined(CONFIG_KVM_BOOK3S_HV_POSSIBLE) && defined(CONFIG_PPC_RADIX_MMU)
> >  extern void radix_kvm_prefetch_workaround(struct mm_struct *mm);
> > +void do_h_rpt_invalidate_prt(unsigned long pid, unsigned long lpid,
> > +			     unsigned long type, unsigned long pg_sizes,
> > +			     unsigned long start, unsigned long end);
> >  #else
> >  static inline void radix_kvm_prefetch_workaround(struct mm_struct *mm) { }
> > +static inline void do_h_rpt_invalidate_prt(unsigned long pid,
> > +					   unsigned long lpid,
> > +					   unsigned long type,
> > +					   unsigned long pg_sizes,
> > +					   unsigned long start,
> > +					   unsigned long end) { }
> 
> Since the only plausible caller is in KVM HV code, why do you need the
> #else clause.

The call to the above routine is prevented for non-radix guests
in KVM HV code at runtime using kvm_is_radix() check and not by
CONFIG_PPC_RADIX_MMU. Hence the #else version would be needed.

Regards,
Bharata.
