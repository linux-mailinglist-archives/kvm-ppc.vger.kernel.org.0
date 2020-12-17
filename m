Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F76E2DCDBF
	for <lists+kvm-ppc@lfdr.de>; Thu, 17 Dec 2020 09:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgLQImV (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 17 Dec 2020 03:42:21 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64606 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727255AbgLQImV (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 17 Dec 2020 03:42:21 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BH8UeOs106933;
        Thu, 17 Dec 2020 03:41:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : reply-to : references : mime-version : content-type
 : in-reply-to; s=pp1; bh=acoNfTTlhFDDiyDgzJDBigNk+KOC3U1w6UGfiMk5hEc=;
 b=VOj7GMT1AMNj6XomkyaU3XFF5zif9EZSc7MPXyaGSk0LEtBhk9t3ra9wC50Zqq94AV+Z
 vsnlTFeLkSCV0ZORhwBV2Z1+6f9hYFXPXt2Rlw0hkkAuuRQ2qWRGF5jRbySSG2QIiu9E
 +5N+T+Milz0T6/aMhmJNYhlE9fsu3YNh3dNy4TKI0JF4u/sh5fomVrLo1lx9UseNgH7Z
 TLAPZxxvN3F1DRVrJo6Scrr6MbtZw1jvYAkavYyu4OwDTjcHPVE93XVa2BhOaC8YRXx+
 oFd5oVPLhvTL7AIcx6YdCW8/c2JYYw178yGXqzJZLgRyOMgxxmboIN8kcZ0x6ESc8VyK Rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35g3b1h8vf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 03:41:28 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BH8Uj4l107332;
        Thu, 17 Dec 2020 03:41:27 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35g3b1h8uq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 03:41:27 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BH8bP1e003588;
        Thu, 17 Dec 2020 08:41:26 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 35cng854wg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 08:41:26 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BH8fNNp31654256
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 08:41:23 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B95B4C044;
        Thu, 17 Dec 2020 08:41:23 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A53B04C040;
        Thu, 17 Dec 2020 08:41:21 +0000 (GMT)
Received: from in.ibm.com (unknown [9.85.69.25])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 17 Dec 2020 08:41:21 +0000 (GMT)
Date:   Thu, 17 Dec 2020 14:11:19 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Fabiano Rosas <farosas@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        aneesh.kumar@linux.ibm.com, npiggin@gmail.com, paulus@ozlabs.org,
        mpe@ellerman.id.au, david@gibson.dropbear.id.au
Subject: Re: [PATCH v2 1/2] KVM: PPC: Book3S HV: Add support for
 H_RPT_INVALIDATE
Message-ID: <20201217084119.GC775394@in.ibm.com>
Reply-To: bharata@linux.ibm.com
References: <20201216085447.1265433-1-bharata@linux.ibm.com>
 <20201216085447.1265433-2-bharata@linux.ibm.com>
 <87v9d174hq.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v9d174hq.fsf@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_04:2020-12-15,2020-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012170058
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Dec 16, 2020 at 07:47:29PM -0300, Fabiano Rosas wrote:
> > +static void do_tlb_invalidate(unsigned long rs, unsigned long target,
> > +			      unsigned long type, unsigned long page_size,
> > +			      unsigned long ap, unsigned long start,
> > +			      unsigned long end)
> > +{
> > +	unsigned long rb;
> > +	unsigned long addr = start;
> > +
> > +	if ((type & H_RPTI_TYPE_ALL) == H_RPTI_TYPE_ALL) {
> > +		rb = PPC_BIT(53); /* IS = 1 */
> > +		do_tlb_invalidate_all(rb, rs);
> > +		return;
> > +	}
> > +
> > +	if (type & H_RPTI_TYPE_PWC) {
> > +		rb = PPC_BIT(53); /* IS = 1 */
> > +		do_tlb_invalidate_pwc(rb, rs);
> > +	}
> > +
> > +	if (!addr && end == -1) { /* PID */
> > +		rb = PPC_BIT(53); /* IS = 1 */
> > +		do_tlb_invalidate_tlb(rb, rs);
> > +	} else { /* EA */
> > +		do {
> > +			rb = addr & ~(PPC_BITMASK(52, 63));
> > +			rb |= ap << PPC_BITLSHIFT(58);
> > +			do_tlb_invalidate_tlb(rb, rs);
> > +			addr += page_size;
> > +		} while (addr < end);
> > +	}
> > +}
> 
> This is all quite similar to _tlbie_pid in mm/book3s64/radix_tlb.c so:
> 
> 1) Shouldn't do_tlb_invalidate be in that file so we could reuse
> __tlbie_pid and __tlbie_va? There are also the tracepoints in that file
> that we might want to reuse.

Will see how much reuse is possible.

> 
> 2) For my own understanding, don't the "fixups" in _tlbie_pid apply to
> this scenario as well?

Yes, I think, will add fixups.

> > +long kvmhv_h_rpti_nested(struct kvm_vcpu *vcpu, unsigned long lpid,
> > +			 unsigned long type, unsigned long pg_sizes,
> > +			 unsigned long start, unsigned long end)
> > +{
> > +	struct kvm_nested_guest *gp;
> > +	long ret;
> > +	unsigned long psize, ap;
> > +
> > +	/*
> > +	 * If L2 lpid isn't valid, we need to return H_PARAMETER.
> > +	 * Nested KVM issues a L2 lpid flush call when creating
> > +	 * partition table entries for L2. This happens even before
> > +	 * the corresponding shadow lpid is created in HV. Until
> > +	 * this is fixed, ignore such flush requests.
> 
> >From the text, it seems that you are talking about kvmhv_set_ptbl_entry
> in L1 calling kvmhv_flush_lpid, but I'm not sure. Could you clarify that
> scenario a bit?

Yes this is the scenario which I am talking about here.

> 
> Maybe it would be good to have a more concrete hint of the issue here or
> in the commit message, since you mentioned this is something that needs
> fixing.

Hmm let me see if I can make the comment more verbose/concrete in the
next version.

Thanks for your review.

Regards,
Bharata.
