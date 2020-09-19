Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F36D2709A3
	for <lists+kvm-ppc@lfdr.de>; Sat, 19 Sep 2020 03:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgISB1y (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 18 Sep 2020 21:27:54 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13312 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726009AbgISB1y (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 18 Sep 2020 21:27:54 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 23CC91B64D794E1EAAC7;
        Sat, 19 Sep 2020 09:27:52 +0800 (CST)
Received: from [10.174.179.91] (10.174.179.91) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Sat, 19 Sep 2020 09:27:47 +0800
Subject: Re: [PATCH -next] powerpc: Convert to DEFINE_SHOW_ATTRIBUTE
To:     Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <kvm-ppc@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
References: <20200716090712.14375-1-miaoqinglang@huawei.com>
 <20200902045118.GD272502@thinks.paulus.ozlabs.org>
From:   miaoqinglang <miaoqinglang@huawei.com>
Message-ID: <088368fc-1bad-d973-39c7-86e8ba5c0f69@huawei.com>
Date:   Sat, 19 Sep 2020 09:27:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200902045118.GD272502@thinks.paulus.ozlabs.org>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.91]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



ÔÚ 2020/9/2 12:51, Paul Mackerras Ð´µÀ:
> On Thu, Jul 16, 2020 at 05:07:12PM +0800, Qinglang Miao wrote:
>> From: Chen Huang <chenhuang5@huawei.com>
>>
>> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
>>
>> Signed-off-by: Chen Huang <chenhuang5@huawei.com>
> 
> For the arch/powerpc/kvm part:
> 
> Acked-by: Paul Mackerras <paulus@ozlabs.org>
> 
> I expect Michael Ellerman will take the patch through his tree.
> 
> Paul.
> .
Hi Michael and Paul,

I spilited this patch and resent them because I noticed that 
<4d4901c6d7>(turn .read -> .read_iter) in linux-next has been reverted.

New patches are against linux-next(20200917), and they can
be applied to mainline cleanly now.

Thanks.
> 
