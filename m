Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A0528DC35
	for <lists+kvm-ppc@lfdr.de>; Wed, 14 Oct 2020 11:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgJNI7n (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 14 Oct 2020 04:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727871AbgJNI7h (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 14 Oct 2020 04:59:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1D6C051101
        for <kvm-ppc@vger.kernel.org>; Tue, 13 Oct 2020 23:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ivg+4ShKhK9J0GIBMLdbzyswn07sEhcY++hSSvHufe4=; b=l+BYk6ta+igFPgPUIzsT+YDnFG
        gV+mlI8oW2Q/9UQThToJzMKf9c1q/o4ndoivvU1ArJoWHAYvZPR/5fJa3ybE2HKQGfEJ76msTHwvk
        g09NSjnV19vWz1lLbzRplSOEm2kXV3Z243YfEyDDN9/wWCiCE38PBOiVajBkLFuogNSEdlZckPIOY
        9i0Ok9UoVdJ5FE09XNoUUp8EKBaE3vlv6+Tq/WvU9PfjkZyW6UNHAVJhh3zpAYUx1cnDPJxSzYEcj
        d2Kov4NfLRcYhQs8gGnKNYFC1jW9Md6yAEjdMJR5o0kxAWSpn80CaR2QvZK8mi35uyCsEcoULd8sH
        VlHo7jJA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSaJh-0007fw-4q; Wed, 14 Oct 2020 06:31:17 +0000
Date:   Wed, 14 Oct 2020 07:31:17 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Ram Pai <linuxram@us.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        farosas@linux.ibm.com, bharata@linux.ibm.com
Subject: Re: [RFC v1 0/2] Plumbing to support multiple secure memory backends.
Message-ID: <20201014063117.GA26161@infradead.org>
References: <1602487663-7321-1-git-send-email-linuxram@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1602487663-7321-1-git-send-email-linuxram@us.ibm.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Please don't add an abstraction without a second implementation.
Once we have the implementation we can consider the tradeoffs.  E.g.
if expensive indirect function calls are really needed vs simple
branches.
