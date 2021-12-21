Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3714947BDCB
	for <lists+kvm-ppc@lfdr.de>; Tue, 21 Dec 2021 10:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbhLUJ6X (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 21 Dec 2021 04:58:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:44504 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231430AbhLUJ6X (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 21 Dec 2021 04:58:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640080702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sWineNtXqbTJ5Et1Uv2T/Fd4TrSY33+kUANsK8qrVRk=;
        b=KQmXJNnWL6fuNsQrMXOj8CBt2NJM2UlclYwrbtL0WZJ3iHttmHxUcqLgPCoh+JCLdbFfsr
        jYAlokVCcIplt2Asw/PV1cHzm8Gxuxq4iuZztzAbDYXw/k4w4oau5UsXMTTp9E5CvdpK7e
        3TXl5Ok/vAVybm+ag5ubk0TZx68vZlI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-5-oFrmVbsyPOuHHfEi7XAeRg-1; Tue, 21 Dec 2021 04:58:21 -0500
X-MC-Unique: oFrmVbsyPOuHHfEi7XAeRg-1
Received: by mail-ed1-f71.google.com with SMTP id w17-20020a056402269100b003f7ed57f96bso9967869edd.16
        for <kvm-ppc@vger.kernel.org>; Tue, 21 Dec 2021 01:58:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sWineNtXqbTJ5Et1Uv2T/Fd4TrSY33+kUANsK8qrVRk=;
        b=hjzyLDT8uOqN6cSt1b6lA9i2eqfR8orzpzPZ81GTplW7qBbbH+AH479oUnOyOC4wa+
         lW/BcT7f3JxJ9yQR2c4Q+V+hhmK8EBTiw0H8g6ZthQiUmGr6JHgP3gXGKpYg4sQXmqaE
         oZn8xEBdnG8WC9OMQszP/QByWo7av7DI6eHo4OgpcMhxDsB7+yLg7KY/EVRuIoaCvRhN
         tXO7SuJbaMpJQeAHXWWqKme1orKzc5Gn5hD55A7VhfQQgx/d8WkPMhAaC6Z44WN8sjun
         xLS63zuUFLKyWmeHJEhvxbNIoBwOJBobmjF7nFPeBYK9fZcCYAk/kxukaPZVc7lx6YjF
         DF1w==
X-Gm-Message-State: AOAM530E6rmvR49oJEVWHgoj/hkyOblCX/dztI6l8niiI7KWDVmWDltr
        Cpu2R9llIZLiCjcnBYOxiLfV/KMmsDFRvNu8FwwLp/rTpFmJ4dZ1DaxrYubiuBpYmyTylw/tdGy
        DJzNMXLK/Kd0h11zAnA==
X-Received: by 2002:a17:907:1703:: with SMTP id le3mr1948175ejc.344.1640080700075;
        Tue, 21 Dec 2021 01:58:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy4f4Fi/3ajjfBqudjvoNO4LlCY2Zi0M/IbSQaY5n0ZYQtqx6OOihln9DSBs6B59SLHKiWUkA==
X-Received: by 2002:a17:907:1703:: with SMTP id le3mr1948160ejc.344.1640080699808;
        Tue, 21 Dec 2021 01:58:19 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id hc14sm3615121ejc.42.2021.12.21.01.58.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 01:58:19 -0800 (PST)
Message-ID: <ae15b86d-6e4d-78be-74da-845c3ef6b9ba@redhat.com>
Date:   Tue, 21 Dec 2021 10:58:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH] scripts/arch-run: Mark migration tests as
 SKIP if ncat is not available
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm-ppc@vger.kernel.org, Eric Auger <eric.auger@redhat.com>
References: <20211221092130.444225-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211221092130.444225-1-thuth@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 12/21/21 10:21, Thomas Huth wrote:
> Instead of failing the tests, we should rather skip them if ncat is
> not available.
> While we're at it, also mention ncat in the README.md file as a
> requirement for the migration tests.
> 
> Resolves: https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/issues/4
> Signed-off-by: Thomas Huth <thuth@redhat.com>

I would rather remove the migration tests.  There's really no reason for 
them, the KVM selftests in the Linux tree are much better: they can find 
migration bugs deterministically and they are really really easy to 
debug.  The only disadvantage is that they are harder to write.

Paolo

> ---
>   README.md             | 4 ++++
>   scripts/arch-run.bash | 2 +-
>   2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/README.md b/README.md
> index 6e6a9d0..a82da56 100644
> --- a/README.md
> +++ b/README.md
> @@ -54,6 +54,10 @@ ACCEL=name environment variable:
>   
>       ACCEL=kvm ./x86-run ./x86/msr.flat
>   
> +For running tests that involve migration from one QEMU instance to another
> +you also need to have the "ncat" binary (from the nmap.org project) installed,
> +otherwise the related tests will be skipped.
> +
>   # Tests configuration file
>   
>   The test case may need specific runtime configurations, for
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 43da998..cd92ed9 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -108,7 +108,7 @@ run_migration ()
>   {
>   	if ! command -v ncat >/dev/null 2>&1; then
>   		echo "${FUNCNAME[0]} needs ncat (netcat)" >&2
> -		return 2
> +		return 77
>   	fi
>   
>   	migsock=$(mktemp -u -t mig-helper-socket.XXXXXXXXXX)
> 

