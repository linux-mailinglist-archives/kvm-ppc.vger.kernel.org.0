Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCC72DCDDC
	for <lists+kvm-ppc@lfdr.de>; Thu, 17 Dec 2020 09:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgLQIte (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 17 Dec 2020 03:49:34 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45894 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727025AbgLQIte (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 17 Dec 2020 03:49:34 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BH8Xbk0131878;
        Thu, 17 Dec 2020 03:48:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : reply-to : references : mime-version : content-type
 : in-reply-to; s=pp1; bh=ozxBhOl1SuqosX/HAVycuIaOOxGz/bupH0buGh3EHyI=;
 b=q3cKLAX76nmVBpKfRu4HTDgstT/NyfVe4/Ik04hkrwUcaYU/cm38ueYeEgRXFZ3XQduE
 I6jCUSEBoLVH6VBqMhfLbWX/+eys58cIaDxN+9dV1n/ECih50s0oxYJ9M12I6qEqkJR6
 qwGX7H2n8rECdt/Px3Z3fra5AvP3x4e/QQeBpxAgzq9zPgKnysT3hx+U2Xl9a3XVqleE
 g+SPgrdlaH/udRKFjokNqLiOzkkOhtzp6dBaws74cuVwZoyiXhDitQDIjWRcFzgKX+Wu
 +jReo3bbAje2xhRLk35uqUPNJbapMnrRgmQYcXoXsbK90UDnD60h4t+ZEIyEUI9qXK+o Mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35g3x70cr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 03:48:44 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BH8cjmV149533;
        Thu, 17 Dec 2020 03:48:44 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35g3x70cqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 03:48:44 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BH8m69g016851;
        Thu, 17 Dec 2020 08:48:42 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 35cng8d4mh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 08:48:42 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BH8meUp41156954
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 08:48:40 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68F5AA4057;
        Thu, 17 Dec 2020 08:48:40 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1AFACA405B;
        Thu, 17 Dec 2020 08:48:39 +0000 (GMT)
Received: from in.ibm.com (unknown [9.85.69.25])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 17 Dec 2020 08:48:38 +0000 (GMT)
Date:   Thu, 17 Dec 2020 14:18:36 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        aneesh.kumar@linux.ibm.com, npiggin@gmail.com, paulus@ozlabs.org,
        mpe@ellerman.id.au
Subject: Re: [PATCH v2 1/2] KVM: PPC: Book3S HV: Add support for
 H_RPT_INVALIDATE
Message-ID: <20201217084836.GD775394@in.ibm.com>
Reply-To: bharata@linux.ibm.com
References: <20201216085447.1265433-1-bharata@linux.ibm.com>
 <20201216085447.1265433-2-bharata@linux.ibm.com>
 <20201217034215.GE310465@yekko.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217034215.GE310465@yekko.fritz.box>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_04:2020-12-15,2020-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 mlxscore=0 adultscore=0 priorityscore=1501 phishscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012170061
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Dec 17, 2020 at 02:42:15PM +1100, David Gibson wrote:
> On Wed, Dec 16, 2020 at 02:24:46PM +0530, Bharata B Rao wrote:
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
> > +
> > +static long kvmppc_h_rpt_invalidate(struct kvm_vcpu *vcpu,
> > +				    unsigned long pid, unsigned long target,
> > +				    unsigned long type, unsigned long pg_sizes,
> > +				    unsigned long start, unsigned long end)
> > +{
> > +	unsigned long rs, ap, psize;
> > +
> > +	if (!kvm_is_radix(vcpu->kvm))
> > +		return H_FUNCTION;
> 
> IIUC The cover note said this case was H_NOT_SUPPORTED, rather than H_FUNCTION.
> 
> > +
> > +	if (end < start)
> > +		return H_P5;
> > +
> > +	if (type & H_RPTI_TYPE_NESTED) {
> > +		if (!nesting_enabled(vcpu->kvm))
> > +			return H_FUNCTION;
> 
> Likewise, I'm not sure that H_FUNCTION is the right choice here.

Yes to both, will switch to H_FUNCTION in the next iteration.

> 
> > +
> > +		/* Support only cores as target */
> > +		if (target != H_RPTI_TARGET_CMMU)
> > +			return H_P2;
> > +
> > +		return kvmhv_h_rpti_nested(vcpu, pid,
> > +					   (type & ~H_RPTI_TYPE_NESTED),
> > +					    pg_sizes, start, end);
> > +	}
> > +
> > +	rs = pid << PPC_BITLSHIFT(31);
> > +	rs |= vcpu->kvm->arch.lpid;
> > +
> > +	if (pg_sizes & H_RPTI_PAGE_64K) {
> > +		psize = rpti_pgsize_to_psize(pg_sizes & H_RPTI_PAGE_64K);
> > +		ap = mmu_get_ap(psize);
> > +		do_tlb_invalidate(rs, target, type, (1UL << 16), ap, start,
> > +				  end);
> 
> Should these be conditional on the TLB flag in type?

Didn't quite get you. Do you mean that depending on the type flag
we may not need to do invalidations for different page sizes
separately?

Regards,
Bharata.
