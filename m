Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D372EC94E
	for <lists+kvm-ppc@lfdr.de>; Thu,  7 Jan 2021 05:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726051AbhAGEJo (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 6 Jan 2021 23:09:44 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52530 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725803AbhAGEJo (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 6 Jan 2021 23:09:44 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10743l1p058704;
        Wed, 6 Jan 2021 23:08:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : reply-to : references : mime-version : content-type
 : in-reply-to; s=pp1; bh=b1OhnpERz+OZzeE628X1oNdxkVzqJI1Q0iUVqfk74UM=;
 b=i7nHNYTkhvOC8uXnj2IJjCNIuKk7WV5rN7N34N29dYqLkvIYDyzNSHtWA9/xeVXq9yt/
 UcxWbTJKY9WQLJGGz+TVBhHaNSQEj7BiWna4ChFSHjncOQKBUqBGssNIHO5XgnD4ZSWN
 95cni7htx9TX89JrHrp7cC+0Kg6bGHDZYpM/HXT9dzzMCHrshw9xt45UoVx6A0JbfgCR
 H5741+e/REdF+M7n8BkKIQy6y2ZWtD6diEk+TboAXxDj1CaiNSu44SMm9y+txESihUv6
 qmO5VS6/ytNLWhwVdebTgMCfYEIldJsXIqD2t6/n+NQB0EwGArJ7pgsZjdREX9YdG4G/ Qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35wt0bh730-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jan 2021 23:08:55 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10744Lcd060325;
        Wed, 6 Jan 2021 23:08:55 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35wt0bh71u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jan 2021 23:08:55 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10748LTR018983;
        Thu, 7 Jan 2021 04:08:51 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 35tg3hcgm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 04:08:51 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10748mog41746902
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Jan 2021 04:08:48 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5DB8A404D;
        Thu,  7 Jan 2021 04:08:48 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A0B1A4053;
        Thu,  7 Jan 2021 04:08:47 +0000 (GMT)
Received: from in.ibm.com (unknown [9.85.71.15])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  7 Jan 2021 04:08:46 +0000 (GMT)
Date:   Thu, 7 Jan 2021 09:38:44 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Fabiano Rosas <farosas@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        aneesh.kumar@linux.ibm.com, npiggin@gmail.com, paulus@ozlabs.org,
        mpe@ellerman.id.au, david@gibson.dropbear.id.au
Subject: Re: [PATCH v3 1/2] KVM: PPC: Book3S HV: Add support for
 H_RPT_INVALIDATE
Message-ID: <20210107040844.GA2158493@in.ibm.com>
Reply-To: bharata@linux.ibm.com
References: <20210105090557.2150104-1-bharata@linux.ibm.com>
 <20210105090557.2150104-2-bharata@linux.ibm.com>
 <87k0sp95g0.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0sp95g0.fsf@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-07_02:2021-01-06,2021-01-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 malwarescore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101070021
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Jan 06, 2021 at 05:27:27PM -0300, Fabiano Rosas wrote:
> Bharata B Rao <bharata@linux.ibm.com> writes:
> > +
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
> > +	 *
> > +	 * However, nested KVM issues a L2 lpid flush call when creating
> > +	 * partition table entries for L2. This happens even before the
> > +	 * corresponding shadow lpid is created in HV which happens in
> > +	 * H_ENTER_NESTED call. Since we can't differentiate this case from
> > +	 * the invalid case, we ignore such flush requests and return success.
> > +	 */
> 
> So for a nested lpid the H_TLB_INVALIDATE in:
> 
> kvmppc_core_init_vm_hv -> kvmppc_setup_partition_table ->
> kvmhv_set_ptbl_entry -> kvmhv_flush_lpid
> 
> has always been a noop? It seems that we could just skip
> kvmhv_flush_lpid in L1 during init_vm then.

May be, but I suppose that flush is required and could be fixed
eventually.

Regards,
Bharata.
