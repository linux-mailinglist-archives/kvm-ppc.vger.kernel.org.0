Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93076274DB2
	for <lists+kvm-ppc@lfdr.de>; Wed, 23 Sep 2020 02:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgIWALc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Sep 2020 20:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727015AbgIWAL2 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Sep 2020 20:11:28 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC6AC0613D1;
        Tue, 22 Sep 2020 17:11:27 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4Bwz9m0BF2z9sTC; Wed, 23 Sep 2020 10:11:23 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1600819884; bh=m9GHPNW/2K3Mjvs2CsrXbfRUodKWSPQ095s2qLR2VpQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JxiasQgk2Gc0tHgASYaAjH9YcNwSlENF2bedN0m/hNvUQ4nh1PLeMl8IJFFcBe9T+
         T6uIdkVEupvrvzoJcsqIC4wUOsJCdW5BwhOhmPYuDTczeSJofcrlRyGEJieedte9d2
         7bDtvUX2LV6MzYLX+VDzrkHOqRgALIrhNABqG9cCAdExw0MfrZDTYz2oYoEQAWX8mq
         12zvrJtvh+2wbTPQeejoUZVtPzsdP1Ga8Isrk2xk95FTy2Nf7l4WBMpIqB6no92tfE
         qM/8MXmTYst/0Tz9sLQtOLZU7ZiBVtamNJ00F8IiYojbpA413Yy6SzOWIDsLu6MVp2
         hJpGCP03732wg==
Date:   Wed, 23 Sep 2020 10:08:32 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Jing Xiangfeng <jingxiangfeng@huawei.com>
Cc:     mpe@ellerman.id.au, benh@kernel.crashing.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: PPC: Book3S: Remove redundant initialization of
 variable ret
Message-ID: <20200923000832.GC531519@thinks.paulus.ozlabs.org>
References: <20200919071230.125798-1-jingxiangfeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200919071230.125798-1-jingxiangfeng@huawei.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat, Sep 19, 2020 at 03:12:30PM +0800, Jing Xiangfeng wrote:
> The variable ret is being initialized with '-ENOMEM' that is meaningless.
> So remove it.
> 
> Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>

Thanks, applied.

Paul.
