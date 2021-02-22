Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495F43210D4
	for <lists+kvm-ppc@lfdr.de>; Mon, 22 Feb 2021 07:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhBVG0f (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Feb 2021 01:26:35 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37460 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229852AbhBVG0e (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Feb 2021 01:26:34 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11M6Ed6h017520;
        Mon, 22 Feb 2021 01:25:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : reply-to : references : mime-version : content-type
 : in-reply-to; s=pp1; bh=FwuNTTcqLG4LZyFlFfSRGTehbGBQdjAVPJODaNMbETQ=;
 b=cmJuDmjkxGBtyzFx2mX9pmFHrQacJVTUhxIkwrH6tLvzvLObRKR64PrIGAEqkhNe33G/
 p3Ig7hKtk3Ck5gpMSVqxbesIj5oTqmSdEqzh38bqCXDkqpsaW0CoYLRCt5Kq0CUDd2tW
 GKRDldV5nGSDZkJ8UOcY/meVdyO9FixXcUSwoDF9OjHZY56FXsLAmgCzIbvEmAWVM4Iy
 nPm66QzJWc2/eBulDjUIJXSENpNLqkLV8Nm4YQj+ReHVr15o+zY2ejlG3b5w2ZUaOEy4
 GrGXUCeo4eAkfJfHE0H1o5NB8xVTHibpT+DSnmMAiDpqqf79yHGg1/fs3oetd9/bHBvA 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36v760gatq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 01:25:40 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11M6F2nf020082;
        Mon, 22 Feb 2021 01:25:39 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36v760gass-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 01:25:39 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11M6NOsN030442;
        Mon, 22 Feb 2021 06:25:37 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 36tt288pns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 06:25:37 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11M6PY3429950460
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Feb 2021 06:25:34 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FFAFA4057;
        Mon, 22 Feb 2021 06:25:34 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0E3DA4040;
        Mon, 22 Feb 2021 06:25:32 +0000 (GMT)
Received: from in.ibm.com (unknown [9.85.69.50])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 22 Feb 2021 06:25:32 +0000 (GMT)
Date:   Mon, 22 Feb 2021 11:55:30 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        aneesh.kumar@linux.ibm.com, npiggin@gmail.com, paulus@ozlabs.org,
        mpe@ellerman.id.au, farosas@linux.ibm.com
Subject: Re: [PATCH v4 1/3] powerpc/book3s64/radix/tlb: tlbie primitives for
 process-scoped invalidations from guests
Message-ID: <20210222062530.GA3672042@in.ibm.com>
Reply-To: bharata@linux.ibm.com
References: <20210215063542.3642366-1-bharata@linux.ibm.com>
 <20210215063542.3642366-2-bharata@linux.ibm.com>
 <YCxiUCm/UCJJGOJD@yekko.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCxiUCm/UCJJGOJD@yekko.fritz.box>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-21_14:2021-02-18,2021-02-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 mlxlogscore=943 mlxscore=0 bulkscore=0 impostorscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102220055
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Feb 17, 2021 at 11:24:48AM +1100, David Gibson wrote:
> On Mon, Feb 15, 2021 at 12:05:40PM +0530, Bharata B Rao wrote:
> > H_RPT_INVALIDATE hcall needs to perform process scoped tlbie
> > invalidations of L1 and nested guests from L0. This needs RS register
> > for TLBIE instruction to contain both PID and LPID. Introduce
> > primitives that execute tlbie instruction with both PID
> > and LPID set in prepartion for H_RPT_INVALIDATE hcall.
> > 
> > While we are here, move RIC_FLUSH definitions to header file
> > and introduce helper rpti_pgsize_to_psize() that will be needed
> > by the upcoming hcall.
> > 
> > Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
> > ---
> >  .../include/asm/book3s/64/tlbflush-radix.h    |  18 +++
> >  arch/powerpc/mm/book3s64/radix_tlb.c          | 122 +++++++++++++++++-
> >  2 files changed, 136 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/powerpc/include/asm/book3s/64/tlbflush-radix.h b/arch/powerpc/include/asm/book3s/64/tlbflush-radix.h
> > index 94439e0cefc9..aace7e9b2397 100644
> > --- a/arch/powerpc/include/asm/book3s/64/tlbflush-radix.h
> > +++ b/arch/powerpc/include/asm/book3s/64/tlbflush-radix.h
> > @@ -4,6 +4,10 @@
> >  
> >  #include <asm/hvcall.h>
> >  
> > +#define RIC_FLUSH_TLB 0
> > +#define RIC_FLUSH_PWC 1
> > +#define RIC_FLUSH_ALL 2
> > +
> >  struct vm_area_struct;
> >  struct mm_struct;
> >  struct mmu_gather;
> > @@ -21,6 +25,20 @@ static inline u64 psize_to_rpti_pgsize(unsigned long psize)
> >  	return H_RPTI_PAGE_ALL;
> >  }
> >  
> > +static inline int rpti_pgsize_to_psize(unsigned long page_size)
> > +{
> > +	if (page_size == H_RPTI_PAGE_4K)
> > +		return MMU_PAGE_4K;
> > +	if (page_size == H_RPTI_PAGE_64K)
> > +		return MMU_PAGE_64K;
> > +	if (page_size == H_RPTI_PAGE_2M)
> > +		return MMU_PAGE_2M;
> > +	if (page_size == H_RPTI_PAGE_1G)
> > +		return MMU_PAGE_1G;
> > +	else
> > +		return MMU_PAGE_64K; /* Default */
> > +}
> 
> Would it make sense to put the H_RPT_PAGE_ tags into the
> mmu_psize_defs table and scan that here, rather than open coding the
> conversion?

I will give this a try and see how it looks.

Otherwise the changes in the patch which are mainly about
introducing primitives that require to set both PID and LPID
for tlbie instruction - do they look right?

Regards,
Bharata.
