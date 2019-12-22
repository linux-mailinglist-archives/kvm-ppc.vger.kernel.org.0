Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 312FF128DE4
	for <lists+kvm-ppc@lfdr.de>; Sun, 22 Dec 2019 13:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfLVMSL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 22 Dec 2019 07:18:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21826 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726189AbfLVMSL (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 22 Dec 2019 07:18:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577017090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gVcwDJ9q7mHGB0f2gxBplUO1RgXxxYA7NYBgVoLV4zs=;
        b=Mf5nXXr4SauZPTG6gvbGWloQJPjfHtiim+024WI7jV8BvhUdHJQJN7wPhxyH8ckmortjfc
        fWYuu0xoq98d1O2mvPaTpHdOjtqtEKcahf2dgM5hmxtr1V6sYc8hV5hwqYU1i7CHjMnTKE
        go7l8dGg8jJOfJwwdmL/wjR2QwriaCE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-uN3VEexOMEGm8JdB3ynimA-1; Sun, 22 Dec 2019 07:18:04 -0500
X-MC-Unique: uN3VEexOMEGm8JdB3ynimA-1
Received: by mail-wr1-f71.google.com with SMTP id z15so3863901wrw.0
        for <kvm-ppc@vger.kernel.org>; Sun, 22 Dec 2019 04:18:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gVcwDJ9q7mHGB0f2gxBplUO1RgXxxYA7NYBgVoLV4zs=;
        b=YAUKjysPp4vWqIUC7RQH5g2QSGg5wS6yQmRZ83C3c8a+X+TQKALlOE+I5mLVtt2FSi
         VIXl3yhmR4aZWGv9tGA/Ai0A/eFGv5InUV0sLUai1zbTlyAqjrq7lwSINkcSytohfah5
         kIUi8+QGpCSN6q/UmiTIEIESlx2wmEcHl1w8dZlOWeO7Urupl1JKobQ/2KJPUWJvuQrw
         ZM+GRX8q4dtD+5rrEe8G0Xkv2rMsZA8G8NC5BqEVgQCknXOMha+bnDjfnV2aNvcu3YuA
         xV9mKH5JeeHFE7FHiHawTX6hriCu8hxYdR2NhNPIbPATnVGpuDxtmCJzHNruC9mkCtOs
         UwWQ==
X-Gm-Message-State: APjAAAUlzdjKzx77A/7zLxNXdIPYS7GpHVdIYBEbOQNUQz0GXw0JV1fp
        OpoxXjFNhRw6Ivxv+wrjnhqjWQKecuFfVDAnrMacTlV5AzFgBhwz+reyhgPQzqfflkFSFNijuXp
        Ridf6VZXQEvF99vXguA==
X-Received: by 2002:adf:ea51:: with SMTP id j17mr25281573wrn.83.1577017083065;
        Sun, 22 Dec 2019 04:18:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqx9KSkR+4EMtJDrj1y3LsZ/vh9fax2RGIQnEf6Wg1AUH38J0MO5GcK4ZJoEwziC8drrgnmk5A==
X-Received: by 2002:adf:ea51:: with SMTP id j17mr25281552wrn.83.1577017082869;
        Sun, 22 Dec 2019 04:18:02 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:7009:9cf0:6204:f570? ([2001:b07:6468:f312:7009:9cf0:6204:f570])
        by smtp.gmail.com with ESMTPSA id n187sm1522196wme.28.2019.12.22.04.18.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Dec 2019 04:18:02 -0800 (PST)
Subject: Re: [GIT PULL] Please pull my kvm-ppc-fixes-5.5-1 tag
To:     Paul Mackerras <paulus@ozlabs.org>, kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org
References: <20191219001912.GA12288@blackberry>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a82fc920-66b4-4c0a-89ea-500df2993fa3@redhat.com>
Date:   Sun, 22 Dec 2019 13:18:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191219001912.GA12288@blackberry>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 19/12/19 01:19, Paul Mackerras wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-fixes-5.5-1

Pulled, thanks.

Paolo

