Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 358A53BED66
	for <lists+kvm-ppc@lfdr.de>; Wed,  7 Jul 2021 19:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhGGRvi (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 7 Jul 2021 13:51:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51380 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230166AbhGGRvi (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 7 Jul 2021 13:51:38 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167HWbYh187109;
        Wed, 7 Jul 2021 13:48:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=NDEBxeTS7s1k6pRYCNSJ7aCm00YAuctFmqP0zorWSiE=;
 b=ex0IXmMzdw4FO6U9cr2u5wMtpH9bGHCim7ALuQRNrWDkVMmbFrmjIHDKMheJFa2zDacT
 1ha1HqVXchc5kmBYzGQsXY1iMz0dtQW8IlMuuHBe0jPD1xr6epBFIJERc6SV1v5SvKlw
 BP72nRjD1XO9p+Buq92VAIZL3tkzh3bS7l7cg/24mHqhNaFHCzBk3eYH7zS54DYQOIk0
 4ODzKfagzDONeddFRTP4B9htVOFWWv3aQkS0fqYBOcLC/lgBBUXJ2GtJdbAOBKtTgN4n
 ogcFC4TlyYaWSeANQaIRoxK/d9Gnuha6WWhGcVklZ1J992n2L8Hy3k5ul/tTqrpf3R84 YA== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39m5q2x19g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 13:48:48 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 167HlIcu032746;
        Wed, 7 Jul 2021 17:48:48 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03dal.us.ibm.com with ESMTP id 39jhq0853m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 17:48:48 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 167HmkCZ21168468
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Jul 2021 17:48:46 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC716BE059;
        Wed,  7 Jul 2021 17:48:46 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44DD8BE054;
        Wed,  7 Jul 2021 17:48:46 +0000 (GMT)
Received: from localhost (unknown [9.211.60.181])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Wed,  7 Jul 2021 17:48:45 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>
Subject: Re: [PATCH kernel] KVM: PPC: Book3S HV: Make unique debugfs nodename
In-Reply-To: <20210707041344.3803554-1-aik@ozlabs.ru>
References: <20210707041344.3803554-1-aik@ozlabs.ru>
Date:   Wed, 07 Jul 2021 14:48:43 -0300
Message-ID: <87zguynhfo.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IcfIZtKnVA1Vqus5_feAkXlEKRDzSS3e
X-Proofpoint-GUID: IcfIZtKnVA1Vqus5_feAkXlEKRDzSS3e
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-07_08:2021-07-06,2021-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 bulkscore=0 clxscore=1011 impostorscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107070101
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Alexey Kardashevskiy <aik@ozlabs.ru> writes:

> Currently it is vm-$currentpid which works as long as there is just one
> VM per the userspace (99.99% cases) but produces a bunch
> of "debugfs: Directory 'vm16679' with parent 'kvm' already present!"
> when syzkaller (syscall fuzzer) is running so only one VM is present in
> the debugfs for a given process.
>
> This changes the debugfs node to include the LPID which alone should be
> system wide unique. This leaves the existing pid for the convenience of
> matching the VM's debugfs with the running userspace process (QEMU).
>
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>

> ---
>  arch/powerpc/kvm/book3s_hv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 1d1fcc290fca..0223ddc0eed0 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -5227,7 +5227,7 @@ static int kvmppc_core_init_vm_hv(struct kvm *kvm)
>  	/*
>  	 * Create a debugfs directory for the VM
>  	 */
> -	snprintf(buf, sizeof(buf), "vm%d", current->pid);
> +	snprintf(buf, sizeof(buf), "vm%d-lp%ld", current->pid, lpid);
>  	kvm->arch.debugfs_dir = debugfs_create_dir(buf, kvm_debugfs_dir);
>  	kvmppc_mmu_debugfs_init(kvm);
>  	if (radix_enabled())
