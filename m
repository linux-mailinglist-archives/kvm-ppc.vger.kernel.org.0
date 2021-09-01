Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4CE3FDDEF
	for <lists+kvm-ppc@lfdr.de>; Wed,  1 Sep 2021 16:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239646AbhIAOqQ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 1 Sep 2021 10:46:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14859 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234001AbhIAOqP (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 1 Sep 2021 10:46:15 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 181Eamvj191054;
        Wed, 1 Sep 2021 10:45:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=1qTUVJI2RHzEhH1wphfac8agLQU5xQlWU5Gl+ySbOy4=;
 b=OQRn4e7wbSF1nKIPdPe1SD+SpdjuuBVntl66XInmfkCKoHKsVH/jY/hFvIEzj3Fwqc7n
 G/sscFbZ5z9WP6CiFGNo+q2Sb61RG6rLm8+bxjk1VAkhrVlzPOR4ueabci3vSPyAh/db
 zzWmWoXch+xYy0gzMjKXCYXzPO9UbXxfpuhUjeofIIfcEcXqh3fC1kghbFJNWQRaTlKb
 rjT0Zx4m1T3ljQdjbOSgbIKi0fcuSJ4OypqRbC3hqtSrS+yKKjH8kihOZyolc97mOZyn
 IbwOS0S6xlw25lsE7VY8ygPRsF24WVJHaZRt4uaJ3TAwXmR1YW48GQ5PH/YDpcTMhSks Iw== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3at6xm88tx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Sep 2021 10:45:15 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 181ESmQt016320;
        Wed, 1 Sep 2021 14:45:14 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02wdc.us.ibm.com with ESMTP id 3aqcsd2549-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Sep 2021 14:45:14 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 181EjDLM23396836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 14:45:13 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D43C112076;
        Wed,  1 Sep 2021 14:45:13 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65AB4112091;
        Wed,  1 Sep 2021 14:45:12 +0000 (GMT)
Received: from localhost (unknown [9.211.58.54])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTPS;
        Wed,  1 Sep 2021 14:45:11 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH kernel] KVM: PPC: Book3S: Suppress failed alloc warning
 in H_COPY_TOFROM_GUEST
In-Reply-To: <20210901084550.1658699-1-aik@ozlabs.ru>
References: <20210901084550.1658699-1-aik@ozlabs.ru>
Date:   Wed, 01 Sep 2021 11:45:09 -0300
Message-ID: <87ilzkuzgq.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Tq1OfXfRfWMrsxWWq0Llrcs1zo2g3It0
X-Proofpoint-ORIG-GUID: Tq1OfXfRfWMrsxWWq0Llrcs1zo2g3It0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-01_04:2021-09-01,2021-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 mlxlogscore=999 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2109010085
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Alexey Kardashevskiy <aik@ozlabs.ru> writes:

> H_COPY_TOFROM_GUEST is an hcall for an upper level VM to access its nested
> VMs memory. The userspace can trigger WARN_ON_ONCE(!(gfp & __GFP_NOWARN))
> in __alloc_pages() by constructing a tiny VM which only does
> H_COPY_TOFROM_GUEST with a too big GPR9 (number of bytes to copy).
>
> This silences the warning by adding __GFP_NOWARN.
>
> Spotted by syzkaller.
>
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>

>  arch/powerpc/kvm/book3s_hv_nested.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
> index e57c08b968c0..a2e34efb8d31 100644
> --- a/arch/powerpc/kvm/book3s_hv_nested.c
> +++ b/arch/powerpc/kvm/book3s_hv_nested.c
> @@ -580,7 +580,7 @@ long kvmhv_copy_tofrom_guest_nested(struct kvm_vcpu *vcpu)
>  	if (eaddr & (0xFFFUL << 52))
>  		return H_PARAMETER;
>
> -	buf = kzalloc(n, GFP_KERNEL);
> +	buf = kzalloc(n, GFP_KERNEL | __GFP_NOWARN);
>  	if (!buf)
>  		return H_NO_MEM;
