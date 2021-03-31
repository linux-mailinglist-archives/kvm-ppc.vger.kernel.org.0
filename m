Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5968534F80F
	for <lists+kvm-ppc@lfdr.de>; Wed, 31 Mar 2021 06:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhCaEjZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 31 Mar 2021 00:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbhCaEjD (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 31 Mar 2021 00:39:03 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A793C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 30 Mar 2021 21:39:03 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4F9D9K0dlFz9sWK; Wed, 31 Mar 2021 15:39:01 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1617165541; bh=EfjObLQOzMXhjT6h30t44ilURVoqwn+72w7vsZQ14NE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u5Hl5IUFtZg2NE2FCeBPxG16fPFNmRtf76YZsbwqPpYv+nKyGO6NIxazFxhJbqiIp
         g869jUeobY4be8RflEfGsxfmvIQxgu3MdgDPZczNzFINBmROSU/Pn01jC4onvtkmYx
         cOUDkfcDS/xey1jpa2Edc4nG/MoadStt7b4WNpRLVleVa1wJMeoMuqUcihRJkyaGJp
         gE7cdZhbglNBFrrkPeNPA63DbHygQ6zI1FP+UirXJSSiDsqggEGV3DzYgwcoJ1e43N
         VPkWQO+4nGYrsaibtXqnVpZmkwsZaDIztS+27izwNzhIVLEPr6QXiow5iVmV/RVnMN
         8Atfm0Jd2Pi3A==
Date:   Wed, 31 Mar 2021 15:38:54 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Daniel Axtens <dja@axtens.net>
Subject: Re: [PATCH v4 06/46] KVM: PPC: Book3S HV: remove unused
 kvmppc_h_protect argument
Message-ID: <YGP83mTXY/LQzAR8@thinks.paulus.ozlabs.org>
References: <20210323010305.1045293-1-npiggin@gmail.com>
 <20210323010305.1045293-7-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323010305.1045293-7-npiggin@gmail.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Mar 23, 2021 at 11:02:25AM +1000, Nicholas Piggin wrote:
> The va argument is not used in the function or set by its asm caller,
> so remove it to be safe.
> 
> Reviewed-by: Daniel Axtens <dja@axtens.net>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Acked-by: Paul Mackerras <paulus@ozlabs.org>
