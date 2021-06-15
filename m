Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375F63A815D
	for <lists+kvm-ppc@lfdr.de>; Tue, 15 Jun 2021 15:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbhFONwe (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 15 Jun 2021 09:52:34 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:10076 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbhFONwe (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 15 Jun 2021 09:52:34 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G48l706w9zZdQB;
        Tue, 15 Jun 2021 21:47:31 +0800 (CST)
Received: from dggema766-chm.china.huawei.com (10.1.198.208) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 15 Jun 2021 21:50:25 +0800
Received: from [10.174.177.210] (10.174.177.210) by
 dggema766-chm.china.huawei.com (10.1.198.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 15 Jun 2021 21:50:25 +0800
Subject: Re: [PATCH] KVM: PPC: Book3S PR: remove unused define in
 kvmppc_mmu_book3s_64_xlate
To:     <paulus@ozlabs.org>, <mpe@ellerman.id.au>,
        <benh@kernel.crashing.org>
CC:     <kvm-ppc@vger.kernel.org>, <yukuai3@huawei.com>
References: <20210604081303.3701171-1-yangerkun@huawei.com>
From:   yangerkun <yangerkun@huawei.com>
Message-ID: <2a659d67-48f2-309f-bbb3-b0fe2d64b94a@huawei.com>
Date:   Tue, 15 Jun 2021 21:50:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210604081303.3701171-1-yangerkun@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.210]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema766-chm.china.huawei.com (10.1.198.208)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Ping...

在 2021/6/4 16:13, yangerkun 写道:
> arch/powerpc/kvm/book3s_64_mmu.c:199:6: warning: variable ‘v’ set but
> not used [-Wunused-but-set-variable]
>    199 |  u64 v, r;
>        |      ^
> 
> Fix it by remove the define.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: yangerkun <yangerkun@huawei.com>
> ---
>   arch/powerpc/kvm/book3s_64_mmu.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_64_mmu.c b/arch/powerpc/kvm/book3s_64_mmu.c
> index 26b8b27a3755..feee40cb2ba1 100644
> --- a/arch/powerpc/kvm/book3s_64_mmu.c
> +++ b/arch/powerpc/kvm/book3s_64_mmu.c
> @@ -196,7 +196,7 @@ static int kvmppc_mmu_book3s_64_xlate(struct kvm_vcpu *vcpu, gva_t eaddr,
>   	hva_t ptegp;
>   	u64 pteg[16];
>   	u64 avpn = 0;
> -	u64 v, r;
> +	u64 r;
>   	u64 v_val, v_mask;
>   	u64 eaddr_mask;
>   	int i;
> @@ -285,7 +285,6 @@ static int kvmppc_mmu_book3s_64_xlate(struct kvm_vcpu *vcpu, gva_t eaddr,
>   		goto do_second;
>   	}
>   
> -	v = be64_to_cpu(pteg[i]);
>   	r = be64_to_cpu(pteg[i+1]);
>   	pp = (r & HPTE_R_PP) | key;
>   	if (r & HPTE_R_PP0)
> 
